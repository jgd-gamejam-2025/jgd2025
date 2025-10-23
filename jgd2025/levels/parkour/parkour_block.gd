# ParkourBlock.gd
class_name ParkourBlock
extends StaticBody3D

@export var drop_height: float = 10.0
@export var animation_duration: float = 0.4

var original_position: Vector3
var current_tween: Tween
@onready var collision_shape = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

func _ready():
	original_position = self.position
	if not mesh_instance:
		print_rich("[color=red]错误：[/color] ParkourBlock 找不到子节点 'MeshInstance3D'！")

# 命令：下降！
func drop():
	if current_tween:
		current_tween.kill()
		
	collision_shape.set_disabled(true) 
	current_tween = create_tween().set_parallel(true)
	
	var target_pos = original_position - Vector3(0, drop_height, 0)
	current_tween.tween_property(self, "position", target_pos, animation_duration).set_ease(Tween.EASE_IN)
	
	if mesh_instance:
		# --- 1. MODIFIED LINE ---
		# Animate "transparency" TO 1.0 (invisible)
		current_tween.tween_property(mesh_instance, "transparency", 1.0, animation_duration)

# 命令：重置！
func reset():
	if current_tween:
		current_tween.kill()

	position = original_position - Vector3(0, drop_height, 0)
	
	if mesh_instance:
		# --- 2. MODIFIED LINE ---
		# Set "transparency" TO 1.0 (invisible)
		mesh_instance.transparency = 1.0

	current_tween = create_tween().set_parallel(true)
	current_tween.tween_property(self, "position", original_position, animation_duration).set_ease(Tween.EASE_OUT)
	
	if mesh_instance:
		# --- 3. MODIFIED LINE ---
		# Animate "transparency" TO 0.0 (opaque)
		current_tween.tween_property(mesh_instance, "transparency", 0.0, animation_duration)
	
	current_tween.finished.connect(collision_shape.set_disabled.bind(false))
