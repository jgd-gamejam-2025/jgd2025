shader_type canvas_item;

uniform vec2 hole_center;
uniform float hole_radius = 100.0;

void fragment() {
    float dist = distance(FRAGCOORD.xy, hole_center);
    if (dist < hole_radius) {
        discard;
    } else {
        COLOR = texture(TEXTURE, UV);
    }
}