shader_type canvas_item;

// Corrected Line: Removed 'hint_range'
uniform vec2 scroll_offset;

void fragment() {
    // 1. TEXTURE_UV contains the default UV coordinates (0 to 1).
    // 2. We add the scroll_offset, which is controlled by the player's position.
    // 3. We use 'fract()' to keep the UV value between 0 and 1. 
    //    This makes the texture **tile seamlessly**.
    vec2 scrolled_uv = fract(UV + scroll_offset);
    
    // 4. Sample the texture at the new, scrolled UV position.
    COLOR = texture(TEXTURE, scrolled_uv);
}