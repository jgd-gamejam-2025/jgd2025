# floating_cube.gd
# 浮动方块 - 上下浮动效果
extends MeshInstance3D

@export_group("浮动设置")
@export var float_amplitude: float = 0.5  # 浮动幅度
@export var float_speed: float = 1.0  # 浮动速度
@export var random_offset: bool = true  # 随机起始相位

@export_group("旋转设置")
@export var rotate_enabled: bool = true  # 是否旋转
@export var rotation_speed: Vector3 = Vector3(0, 45, 0)  # 旋转速度（度/秒）

@export_group("外观设置")
@export var cube_size: float = 1.0  # 方块大小
@export var emission_strength: float = 2.0  # 发光强度

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
	mesh.size = Vector3.ONE * cube_size
	
	# 创建发光材质
	material = StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	material.emission_enabled = true
	material.emission = Color.WHITE
	material.emission_energy_multiplier = emission_strength
	material.metallic = 0.0
	material.roughness = 0.3
	
	set_surface_override_material(0, material)
	
	# 禁用碰撞（装饰用）
	# 不需要添加碰撞体


func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	
	# 浮动效果
	var float_offset = sin((time + time_offset) * float_speed) * float_amplitude
	position = start_position + Vector3(0, float_offset, 0)
	
	# 旋转效果
	if rotate_enabled:
		rotation_degrees += rotation_speed * delta
