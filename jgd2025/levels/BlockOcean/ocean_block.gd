class_name OceanBlock
extends AnimatableBody3D

@export_group("环境波动")
@export var ambient_fluctuation_height: float = 3
@export var ambient_fluctuation_speed: float = 0.5
# @export var ripple_center_offset: Vector3 = Vector3.ZERO # Manager knows this
@export var ripple_multiplier: float = 0.1 # 波纹密度

@export_group("海啸效果")
@export var drop_height: float = 50
@export var drop_duration: float = 0.3
@export var surge_rise_duration: float = 1.0
@export var reset_duration: float = 0.5

# 内部状态
enum State { FLUCTUATING, DROPPING, SURGING, RESETTING }
var current_state = State.FLUCTUATING

var original_global_position: Vector3 # Still need this
var current_tween: Tween
var original_mesh_scale: Vector3 # <-- New: Store original scale
@onready var collision_shape = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var time_offset: float = 0.0 # Manager calculates this, we just store it

# --- **新**: Manager设置波动参数时会调用 ---
func store_ripple_parameters(center: Vector3, max_dist: float):
	# 计算并存储 time_offset，但不再自己使用
	var distance_from_center = (global_position - center).length()
	time_offset = (max_dist - distance_from_center) * ripple_multiplier

func _ready():
	# 记录初始世界坐标
	original_global_position = self.global_position
	if mesh_instance:
		original_mesh_scale = mesh_instance.scale
	else:
		original_mesh_scale = Vector3.ONE # Default if no mesh found
		print_rich("[color=red]ERROR:[/color] OceanBlockAnim missing MeshInstance3D child.")
	# (省略材质和mesh检查)

# --- **移除**: 不再需要 _physics_process ---
# func _physics_process(delta):
#     (删除这里的代码)

# --- **新**: Manager 调用这个函数来设置位置 ---
func set_fluctuating_y_global(new_global_y: float):
	# 只有在波动状态才接受位置更新
	if current_state == State.FLUCTUATING:
		self.global_position.y = new_global_y

# --- **新**: Manager 调用这些函数来开关碰撞 ---
func enable_collision():
	if collision_shape.disabled: # 只有在禁用时才启用，避免重复设置
		collision_shape.set_disabled(false)

func disable_collision():
	if not collision_shape.disabled: # 只有在启用时才禁用
		collision_shape.set_disabled(true)

# --- ( drop_and_surge, reset_to_fluctuate 保持不变, 但注意它们现在基于 global_position ) ---
func drop_and_surge(surge_height: float):
	if current_state != State.FLUCTUATING: return
	current_state = State.DROPPING
	if current_tween: current_tween.kill()
	disable_collision() # <--- 改用新函数
	current_tween = create_tween()
	var drop_target_global_pos = original_global_position - Vector3(0, drop_height, 0)
	var parallel_drop = current_tween.set_parallel(true)
	parallel_drop.tween_property(self, "global_position", drop_target_global_pos, drop_duration).set_ease(Tween.EASE_IN)
	if mesh_instance:
		parallel_drop.tween_property(mesh_instance, "transparency", 1.0, drop_duration)
	current_tween.finished.connect(func():
		current_state = State.SURGING
		current_tween = create_tween()
		var surge_target_global_pos = original_global_position + Vector3(0, surge_height, 0)
		var parallel_surge = current_tween.set_parallel(true)
		parallel_surge.tween_property(self, "global_position", surge_target_global_pos, surge_rise_duration).set_ease(Tween.EASE_OUT)
		if mesh_instance:
			parallel_surge.tween_property(mesh_instance, "transparency", 0.0, surge_rise_duration * 0.5)
			# Calculate target scale based on original height and surge height
			# Assuming original block is 1 unit high (or original_mesh_scale.y represents its base height)
			# Target height = current Y - original base Y + original height
			# Approximate target scale factor = (surge_height + original_global_position.y) / original_mesh_scale.y IF pivot is at bottom
			# Simpler: Scale Y by the surge height factor relative to original height (assumes original height ~ 1)
			var target_scale_y = original_mesh_scale.y * (1.0 + surge_height) # Adjust if original block height isn't 1
			var target_scale = Vector3(original_mesh_scale.x, target_scale_y, original_mesh_scale.z)
			parallel_surge.tween_property(mesh_instance, "scale", target_scale, surge_rise_duration).set_ease(Tween.EASE_OUT)
	)

func reset_to_fluctuate():
	if current_state != State.SURGING: return
	current_state = State.RESETTING
	if current_tween: current_tween.kill()
	current_tween = create_tween().set_parallel(true)
	current_tween.tween_property(self, "global_position", original_global_position, reset_duration).set_ease(Tween.EASE_IN_OUT)
	if mesh_instance:
		current_tween.tween_property(mesh_instance, "transparency", 0.0, reset_duration * 0.5)
		current_tween.tween_property(mesh_instance, "scale", original_mesh_scale, reset_duration).set_ease(Tween.EASE_IN_OUT)
	current_tween.finished.connect(func():
		enable_collision() # <--- 改用新函数
		current_state = State.FLUCTUATING
	)

func get_current_state() -> State:
	return current_state
