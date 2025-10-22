shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_back, unshaded;

uniform vec4 beam_color : source_color = vec4(0.8, 0.9, 1.0, 1.0);
uniform float emission_strength : hint_range(0.0, 10.0) = 5.0;
uniform float edge_fade : hint_range(0.0, 1.0) = 0.5;
uniform float alpha : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	// 计算距离中心的径向距离（0到1）
	vec2 uv_centered = UV - vec2(0.5, 0.5);
	float distance_from_center = length(uv_centered) * 2.0;
	
	// 创建从中心到边缘的渐变
	float radial_fade = 1.0 - smoothstep(edge_fade, 1.0, distance_from_center);
	
	// 设置发光颜色
	ALBEDO = beam_color.rgb;
	EMISSION = beam_color.rgb * emission_strength * radial_fade;
	ALPHA = alpha * radial_fade;
}
