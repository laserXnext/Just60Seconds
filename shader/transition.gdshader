shader_type canvas_item;

uniform sampler2D mask;
uniform float scale : hint_range(0.0, 1.0, 0.1);

// Cubic easing function: easeInOutCubic
float ease_in_out_cubic(float t) {
    return t < 0.5 ? 4.0 * t * t * t : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
}

void fragment() {
    float eased_scale = ease_in_out_cubic(scale);
    float s = eased_scale * 75.0f;
    int cutoff = int(s / 75.0f);
    vec2 offset = vec2(0.5, 0.5) * (1.0 - s);
    vec4 mask_color = texture(mask, UV * s + offset);
    COLOR.a = 1.0 - mask_color.a + float(cutoff);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
