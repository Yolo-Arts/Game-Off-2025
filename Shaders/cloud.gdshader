shader_type canvas_item;


uniform vec2 tiling = vec2(1.0, 1.0);
uniform vec2 scroll_speed = vec2(0.1, 0.0);
uniform vec4 cloud_color: source_color = vec4(1.0, 1.0, 1.0, 0.8);


uniform float shadow_rotation: hint_range(-3.14, 3.14) = 0.0;
uniform vec2 shadow_offset = vec2(0.2, 0.4);
uniform vec2 shadow_scale = vec2(1.0, 0.5); 
uniform float shadow_opacity: hint_range(0.0, 1.0) = 0.5;


void vertex() {
    UV = UV * tiling + scroll_speed * TIME;
}

void fragment() {
    vec4 noise_sample = texture(TEXTURE, UV);
    
    float cloud_alpha = (1.0 - noise_sample.r) * cloud_color.a;
    
    mat2 rotation_matrix = mat2(vec2(cos(shadow_rotation), -sin(shadow_rotation)), vec2(sin(shadow_rotation), cos(shadow_rotation)));

    vec2 shadow_uv = UV;
    shadow_uv -= 0.5; 
    shadow_uv *= shadow_scale; 
    shadow_uv *= rotation_matrix; 
    shadow_uv += 0.5; 
    shadow_uv += shadow_offset;

    vec4 shadow_noise_sample = texture(TEXTURE, shadow_uv);

    float shadow_alpha = (1.0 - shadow_noise_sample.r) * shadow_opacity;
    float final_alpha = cloud_alpha + shadow_alpha * (1.0 - cloud_alpha);

    COLOR = vec4(cloud_color.rgb, final_alpha);
}