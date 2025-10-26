# orbiting_cube.gd
# 轨道方块 - 围绕中心点旋转
extends Node3D

@export_group("轨道设置")
@export var orbit_radius: float = 2.0  # 轨道半径
@export var orbit_speed: float = 1.0  # 轨道速度
@export var orbit_axis: Vector3 = Vector3.UP  # 轨道轴
@export var random_start_angle: bool = true  # 随机起始角度

@export_group("方块设置")
@export var cube_size: float = 0.8  # 方块大小
@export var cube_rotation_speed: Vector3 = Vector3(0, 90, 0)  # 方块自转速度
@export var emission_strength: float = 2.0  # 发光强度

var angle: float = 0.0
var cube: MeshInstance3D


func _ready():
	# 随机起始角度
	if random_start_angle:
		angle = randf() * TAU
	
	# 创建方块
	cube = MeshInstance3D.new()
	add_child(cube)
	
	# 创建网格
	cube.mesh = BoxMesh.new()
	cube.mesh.size = Vector3.ONE * cube_size
	
	# 创建材质
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	material.emission_enabled = true
	material.emission = Color.WHITE
	material.emission_energy_multiplier = emission_strength
	material.metallic = 0.0
	material.roughness = 0.3
	
	cube.set_surface_override_material(0, material)


func _process(delta):
	# 更新轨道角度
	angle += orbit_speed * delta
	
	# 计算轨道位置
	var orbit_plane = orbit_axis.normalized()
	var perpendicular1 = Vector3.RIGHT if abs(orbit_plane.dot(Vector3.RIGHT)) < 0.9 else Vector3.UP
	perpendicular1 = perpendicular1.cross(orbit_plane).normalized()
	var perpendicular2 = orbit_plane.cross(perpendicular1).normalized()
	
	var orbit_offset = (perpendicular1 * cos(angle) + perpendicular2 * sin(angle)) * orbit_radius
	cube.position = orbit_offset
	
	# 方块自转
	cube.rotation_degrees += cube_rotation_speed * delta
