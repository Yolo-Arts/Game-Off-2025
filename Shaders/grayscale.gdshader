shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);

	float red = screen_color.r;
	float green = screen_color.g;
	float blue = screen_color.b;

	float grayscale = (red + green + blue) / 3.0;

	// to filer by specific colors:
	// screen_color.rgba = screen_color * vec4(1.0, 0.0, 0.0, 1.0);
	screen_color.rgb = vec3(grayscale);
	COLOR = screen_color;
}
