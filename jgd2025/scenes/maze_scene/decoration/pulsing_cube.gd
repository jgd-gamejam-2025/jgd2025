# pulsing_cube.gd
# 脉冲方块 - 大小变化效果
extends MeshInstance3D

@export_group("脉冲设置")
@export var pulse_min_scale: float = 0.8  # 最小缩放
@export var pulse_max_scale: float = 1.2  # 最大缩放
@export var pulse_speed: float = 2.0  # 脉冲速度
@export var random_offset: bool = true  # 随机起始相位

@export_group("浮动设置")
@export var float_enabled: bool = true  # 是否浮动
@export var float_amplitude: float = 0.3  # 浮动幅度
@export var float_speed: float = 0.5  # 浮动速度

@export_group("旋转设置")
@export var rotate_enabled: bool = true  # 是否旋转
@export var rotation_speed: Vector3 = Vector3(15, 30, 15)  # 旋转速度（度/秒）

@export_group("外观设置")
@export var base_size: float = 1.0  # 基础大小
@export var emission_strength: float = 2.5  # 发光强度

var start_position: Vector3
var time_offset: float = 0.0
var material: StandardMaterial3D


func _ready():
	# 保存初始位置
	start_position = position
	
	# 随机时间偏移
	if random_offset:
		time_offset = randf() * TAU
	
	# 创建方块网格
	mesh = BoxMesh.new()
	mesh.size = Vector3.ONE * base_size
	
	# 创建发光材质
	material = StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	material.emission_enabled = true
	material.emission = Color.WHITE
	material.emission_energy_multiplier = emission_strength
	material.metallic = 0.0
	material.roughness = 0.2
	
	set_surface_override_material(0, material)


func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	
	# 脉冲效果（大小变化）
	var pulse_factor = (sin((time + time_offset) * pulse_speed) + 1.0) / 2.0  # 0到1
	var current_scale = lerp(pulse_min_scale, pulse_max_scale, pulse_factor)
	scale = Vector3.ONE * current_scale
	
	# 浮动效果
	if float_enabled:
		var float_offset = sin((time + time_offset) * float_speed) * float_amplitude
		position = start_position + Vector3(0, float_offset, 0)
	
	# 旋转效果
	if rotate_enabled:
		rotation_degrees += rotation_speed * delta
