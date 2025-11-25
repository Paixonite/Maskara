shader_type canvas_item;
uniform vec3 tint_value;
uniform float intensity : hint_range(0, 1) = 0.15;
uniform float threshold : hint_range(0, 255) = 0;
uniform bool weighted = true;	// Determines whether to use normal or weighted averages

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);	
    COLOR.r = pixelColor.r * tint_value.r;
    COLOR.g = pixelColor.g * tint_value.g;
    COLOR.b = pixelColor.b * tint_value.b;
	COLOR.a = pixelColor.a;
}