//
//shader_type canvas_item;
//
//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_enable, filter_nearest;
//
//group_uniforms water;
//uniform sampler2D waterNoise : repeat_enable, filter_nearest;
//uniform sampler2D waterDistortionNoise : repeat_enable, filter_nearest;
//uniform vec4 waterColor : source_color = vec4(0.117, 0.27, 0.58, 1);
//uniform float colorCorection : hint_range(0.0, 1.0, 0.01) = 0.35;
//
//group_uniforms water_waves;
//uniform float distortionForce : hint_range(0.00, .1, 0.001) = .01;
//uniform float WDBrightness : hint_range(0, 3, 0.05) = 1.5;
//uniform float WDFreq : hint_range(0.2, .9, 0.05) = 0.6;
//uniform float WDSize : hint_range(0.6, 1.2, 0.05) = .9;
//uniform float WDSpeed : hint_range(1, 20, 0.05) = 4;
//uniform vec2 tiling = vec2(1);
//uniform vec2 offSetSpeed = vec2(.1);
//
//group_uniforms BG_distortion;
//uniform float backGroundDirX : hint_range(-0.1, 0.1) = 0.01;
//uniform float backGroundDirY : hint_range(-0.1, 0.1) = 0.01;
//
//
//
//
//void fragment() {
	//vec4 color = vec4(waterColor.rgb , 1);
	//
	//vec2 noiseUV = UV * tiling + offSetSpeed * TIME;
	//float noiseValue = texture(waterDistortionNoise, noiseUV).r;
//
	//vec2 waterUV = UV * tiling;
	//waterUV.x += offSetSpeed.x * TIME;
	//waterUV.y += cos(TIME * min(1., offSetSpeed.y)) * 0.01;
	//waterUV = waterUV + noiseValue * distortionForce * WDSpeed;
//
//
	//vec4 noiseColor = texture(waterNoise, waterUV);
	//float intensity = smoothstep(WDFreq, WDSize, noiseColor.r);
	//color.rgb += intensity * vec3(WDBrightness);
	//
	//vec2 backGroundUV = SCREEN_UV;
	//backGroundUV.x += noiseValue * backGroundDirX;
	//backGroundUV.y += noiseValue * backGroundDirY;
//
//
	//color = mix(texture(SCREEN_TEXTURE, backGroundUV),color, 0.2);
//
	//COLOR = mix(color, waterColor, colorCorection);
//
//}

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_enable, filter_nearest;

group_uniforms water;
uniform sampler2D waterNoise : repeat_enable, filter_nearest;
uniform sampler2D waterDistortionNoise : repeat_enable, filter_nearest;
uniform vec4 waterColor : source_color = vec4(0.117, 0.27, 0.58, 1);
uniform float colorCorection : hint_range(0.0, 1.0, 0.01) = 0.35;

group_uniforms water_waves;
uniform float distortionForce : hint_range(0.00, .1, 0.001) = .02; // Increased slightly
uniform float WDBrightness : hint_range(0, 3, 0.05) = 1.5;
uniform float WDFreq : hint_range(0.2, .9, 0.05) = 0.6;
uniform float WDSize : hint_range(0.6, 1.2, 0.05) = .9;
uniform float WDSpeed : hint_range(1, 20, 0.05) = 4;
uniform vec2 tiling = vec2(1);

// Movement 1
uniform vec2 offSetSpeed = vec2(0.05, 0.05);
// Movement 2 (Should be different from Movement 1 to create chaos)
uniform vec2 offSetSpeed2 = vec2(-0.04, 0.02);

group_uniforms BG_distortion;
uniform float backGroundDirX : hint_range(-0.1, 0.1) = 0.05;
uniform float backGroundDirY : hint_range(-0.1, 0.1) = 0.05;

void fragment() {
	vec4 color = vec4(waterColor.rgb , 1);
	
	// --- IMPROVED DISTORTION LOGIC ---
	
	// Sample 1: Moves based on offSetSpeed
	vec2 noiseUV1 = UV * tiling + (offSetSpeed * TIME);
	float noise1 = texture(waterDistortionNoise, noiseUV1).r;
	
	// Sample 2: Moves based on offSetSpeed2 (Different direction)
	vec2 noiseUV2 = UV * tiling + (offSetSpeed2 * TIME);
	float noise2 = texture(waterDistortionNoise, noiseUV2).r;
	
	// Combine them to create a "churning" value (0.0 to 1.0)
	float noiseValue = (noise1 + noise2) * 0.5;

	// ---------------------------------

	vec2 waterUV = UV * tiling;
	
	// Instead of sliding the whole texture linearly, we warp it using our churning noise
	waterUV += noiseValue * distortionForce * WDSpeed;

	vec4 noiseColor = texture(waterNoise, waterUV);
	float intensity = smoothstep(WDFreq, WDSize, noiseColor.r);
	color.rgb += intensity * vec3(WDBrightness);
	
	// Background Refraction
	vec2 backGroundUV = SCREEN_UV;
	// Subtract 0.5 so the distortion pushes both left/right and up/down
	backGroundUV.x += (noiseValue - 0.5) * backGroundDirX;
	backGroundUV.y += (noiseValue - 0.5) * backGroundDirY;

	color = mix(texture(SCREEN_TEXTURE, backGroundUV), color, 0.2);

	COLOR = mix(color, waterColor, colorCorection);
}