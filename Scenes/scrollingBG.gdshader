shader_type canvas_item;

uniform vec2 scroll_offset;

void fragment() {
    vec2 scrolled_uv = fract(UV + scroll_offset);

    COLOR = texture(TEXTURE, scrolled_uv);
}