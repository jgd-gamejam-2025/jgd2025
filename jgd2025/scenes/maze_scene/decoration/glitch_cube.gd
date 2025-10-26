# glitch_cube.gd
# 故障方块 - 随机闪烁和位置跳动效果（数字世界风格）
extends MeshInstance3D

@export_group("故障设置")
@export var glitch_intensity: float = 0.1  # 故障强度（位置偏移）
@export var glitch_frequency: float = 0.2  # 故障频率（每秒触发次数）
@export var blink_enabled: bool = true  # 是否闪烁

@export_group("浮动设置")
@export var float_amplitude: float = 0.4  # 浮动幅度
@export var float_speed: float = 0.8  # 浮动速度

@export_group("旋转设置")
@export var rotation_speed: Vector3 = Vector3(20, 40, 10)  # 旋转速度

@export_group("外观设置")
@export var cube_size: float = 1.0  # 方块大小
@export var emission_strength: float = 3.0  # 发光强度

var start_position: Vector3
var time_offset: float = 0.0
var next_glitch_time: float = 0.0
var glitch_offset: Vector3 = Vector3.ZERO
var material: StandardMaterial3D


func _ready():
	# 保存初始位置
	start_position = position
	time_offset = randf() * TAU
	
	# 创建方块网格
	mesh = BoxMesh.new()
	mesh.size = Vector3.ONE * cube_size
	
	# 创建发光材质
	material = StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	material.emission_enabled = true
	material.emission = Color.WHITE
	material.emission_energy_multiplier = emission_strength
	material.metallic = 0.0
	material.roughness = 0.1
	
	set_surface_override_material(0, material)
	
	_schedule_next_glitch()


func _schedule_next_glitch():
	# 随机安排下次故障时间
	var base_interval = 1.0 / glitch_frequency if glitch_frequency > 0 else 5.0
	next_glitch_time = Time.get_ticks_msec() / 1000.0 + base_interval * randf_range(0.5, 1.5)


func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	
	# 检查是否触发故障
	if time >= next_glitch_time:
		_trigger_glitch()
		_schedule_next_glitch()
	
	# 平滑恢复故障偏移
	glitch_offset = glitch_offset.lerp(Vector3.ZERO, delta * 5.0)
	
	# 浮动效果
	var float_offset = sin((time + time_offset) * float_speed) * float_amplitude
	position = start_position + Vector3(0, float_offset, 0) + glitch_offset
	
	# 旋转效果
	rotation_degrees += rotation_speed * delta


func _trigger_glitch():
	# 随机位置偏移
	glitch_offset = Vector3(
		randf_range(-glitch_intensity, glitch_intensity),
		randf_range(-glitch_intensity, glitch_intensity),
		randf_range(-glitch_intensity, glitch_intensity)
	)
	
	# 随机闪烁
	if blink_enabled and randf() < 0.5:
		visible = false
		get_tree().create_timer(0.05).timeout.connect(func(): visible = true)
