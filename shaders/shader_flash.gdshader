shader_type canvas_item;

uniform vec4 flash_color: source_color;
uniform float flash_mix: hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 out_color = vec4(flash_color.rgb, COLOR.a);
	COLOR = mix(COLOR, out_color, flash_mix);
}
