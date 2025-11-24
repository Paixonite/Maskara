shader_type canvas_item;
uniform vec4 tint_color : source_color = vec4(1, 1, 1, 1);
uniform float intensity : hint_range(0, 1) = 0.15;
uniform bool weighted = true;	// Determines whether to use normal or weighted averages

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	COLOR = mix(COLOR, tint_color, intensity);
	COLOR.a = pixelColor.a;
}