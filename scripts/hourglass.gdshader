shader_type canvas_item;

uniform vec3 target_color : source_color;
uniform float tolerance : hint_range(0.0, 1.0) = 0.1;
uniform float ratio : hint_range(0.0, 0.5) = 0.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	float dist = distance(tex_color.rgb, target_color);
	if (dist < tolerance) {
		// above mid
		if (UV.y < 0.5 && UV.y < ratio) {
			COLOR.a = 0.0;
		}  
		
		// below mid
		if (UV.y > 0.5 && UV.y - 0.25 * distance(UV.x,0.5) < 1.0 - ratio) {
			COLOR.a = 0.0;
		}
		
	}
}
