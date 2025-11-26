shader_type canvas_item;

uniform vec2 global_position;
uniform vec2 screen_size;
uniform float force;
uniform float size;
uniform float thickness;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void fragment(){
	vec2 center = global_position;
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	center.x = center.x / screen_size.x;
	center.x = (center.x - 0.5) / ratio + 0.5;
	center.y = (screen_size.y - center.y) / screen_size.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0) ) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size-0.1, size, length(scaledUV - center))) * smoothstep(size-thickness-0.1, size-thickness, length(scaledUV - center));
	vec2 disp = normalize(SCREEN_UV - center) * force * mask;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
}