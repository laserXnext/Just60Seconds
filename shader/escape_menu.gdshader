shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float pixel_size : hint_range(1.0, 20.0); // Adjusts pixelation size

void fragment() {
    // Calculate the pixelated UV coordinates
    vec2 uv = SCREEN_UV;
    uv = floor(uv * pixel_size) / pixel_size;

    // Sample the texture at the modified UV coordinates
    vec4 color = texture(screen_texture, uv);

    COLOR = color;
}