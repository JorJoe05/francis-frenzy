shader_type canvas_item;

uniform sampler2D screen_tex: hint_screen_texture;
uniform vec4 mask_color: source_color;
uniform vec4 mod_color_bright: source_color;
uniform vec4 mod_color_dim: source_color;

void fragment() {
	vec4 in_tex = texture(screen_tex, SCREEN_UV);
	float col_avg = (in_tex.r + in_tex.g + in_tex.b) / 3.0;
	vec4 mod_tex = mix(mod_color_dim, mod_color_bright, col_avg);
	COLOR = mix(COLOR, mod_tex, float(COLOR == mask_color));
}