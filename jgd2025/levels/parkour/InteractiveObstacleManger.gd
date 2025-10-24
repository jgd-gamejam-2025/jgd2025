# InteractiveObstacleManager.gd
class_name InteractiveObstacleManager extends Node3D

# --- 在检查器中设置你的互动障碍 ---

# 1. 【核心改动】动作定义：这个管理器控制的所有障碍物都会执行这个动作。
@export var obstacle_action: ObstacleAction # 直接引用一个 ObstacleAction 资源

# 2. 障碍物查找方式：
enum ObstacleFindMode {
	FIND_BY_CHILDREN,  # 管理器的所有直接子节点 (Node3D类型) 都会被控制
	FIND_BY_GROUP      # 查找特定组内的所有 Node3D
}
@export var find_mode: ObstacleFindMode = ObstacleFindMode.FIND_BY_CHILDREN
@export var target_group_name: String = "interactive_obstacles" # 如果是按组查找，指定组名


# 3. 触发后，障碍物执行动作的延迟 (Optional)
@export var action_delay: float = 0.0

# 4. 触发后，这个管理器是否应该禁用自身，避免重复触发？
@export var disable_after_trigger: bool = false # 默认改为false，方便多次触发


# --- 内部变量 ---
var triggered: bool = false
var managed_obstacles: Array[Node3D] = [] # 实际管理的障碍物列表
var initial_positions: Dictionary = {}    # 存储每个障碍物的初始位置

var trigger_area: Area3D # 【新】现在这个变量是内部使用的


func _ready():
	# 【核心改动】自动查找子节点中的 Area3D
	trigger_area = null
	for child in get_children():
		if child is Area3D:
			trigger_area = child
			break # 找到第一个 Area3D 就使用它

	if not trigger_area:
		print_rich("[color=red]错误：[/color] InteractiveObstacleManager 未找到子节点中的 'Area3D' 作为触发区域！")
		set_process(false)
		return
	
	if not obstacle_action:
		print_rich("[color=red]错误：[/color] InteractiveObstacleManager 没有设置 'obstacle_action'！请创建一个 ObstacleAction 资源。")
		set_process(false)
		return

	_find_managed_obstacles() # 查找并填充 managed_obstacles 数组

	if managed_obstacles.is_empty():
		print_rich("[color=yellow]警告：[/color] InteractiveObstacleManager 未找到任何受控障碍物。")
	
	# 存储所有障碍物的初始位置
	for obstacle in managed_obstacles:
		initial_positions[obstacle] = obstacle.position
	
	trigger_area.body_entered.connect(_on_trigger_area_body_entered)


# 【新函数】根据查找模式找到所有受控的障碍物
func _find_managed_obstacles():
	managed_obstacles.clear() # 清空旧列表
	
	if find_mode == ObstacleFindMode.FIND_BY_CHILDREN:
		for child in get_children():
			# 确保是3D节点，不是触发区域本身，也不是管理器脚本的另一个实例
			if child is Node3D and child != trigger_area and not (child is InteractiveObstacleManager):
				managed_obstacles.append(child)
	elif find_mode == ObstacleFindMode.FIND_BY_GROUP:
		if not target_group_name.is_empty():
			for node in get_tree().get_nodes_in_group(target_group_name):
				if node is Node3D and not (node is InteractiveObstacleManager): # 排除管理器自身
					managed_obstacles.append(node)
		else:
			print_rich("[color=red]错误：[/color] 查找模式为 FIND_BY_GROUP 但 'target_group_name' 未设置！")


func _on_trigger_area_body_entered(body: Node3D):
	if body.is_in_group("player") and not triggered:
		triggered = true
		if action_delay > 0.0:
			get_tree().create_timer(action_delay).timeout.connect(_execute_actions)
		else:
			_execute_actions()
		
		if disable_after_trigger:
			trigger_area.monitoring = false


func _execute_actions():
	for obstacle in managed_obstacles:
		_perform_action(obstacle, obstacle_action)


func _perform_action(obstacle: Node3D, action: ObstacleAction):
	# 注意：这里我们让障碍物从其当前位置移动，而不是总是从初始位置计算
	# 如果你希望动作总是以初始位置为基准，则应该使用 initial_positions[obstacle]
	# 但对于“归位”的逻辑，确保目标是初始位置
	var current_obstacle_pos = obstacle.position
	var target_position = current_obstacle_pos # 默认是当前位置
	
	# 【重要】确保这里根据当前位置计算目标，而不是 always 从 initial_positions 计算
	# 因为如果障碍物已经移动了，再次触发时，你可能希望它从新位置开始计算移动
	# 如果你的设计是每次都基于初始位置移动，则改为：
	# var target_position = initial_positions[obstacle]
	
	match action.move_type:
		ObstacleAction.MoveType.MOVE_UP:
			target_position.y += action.move_distance
		ObstacleAction.MoveType.MOVE_DOWN:
			target_position.y -= action.move_distance
		ObstacleAction.MoveType.MOVE_LEFT_X:
			target_position.x -= action.move_distance
		ObstacleAction.MoveType.MOVE_RIGHT_X:
			target_position.x += action.move_distance
		ObstacleAction.MoveType.MOVE_FORWARD_Z:
			target_position.z -= action.move_distance
		ObstacleAction.MoveType.MOVE_BACKWARD_Z:
			target_position.z += action.move_distance
		_:
			print_rich("[color=yellow]警告：[/color] 未知移动类型 %s 为障碍物 %s。" % [action.move_type, obstacle.name])
			return
			
	var tween = get_tree().create_tween()
	
	tween.tween_property(obstacle, "position", target_position, action.move_duration)\
		.set_ease(action.ease_type_int as Tween.EaseType)\
		.set_trans(action.transition_type_int as Tween.TransitionType)
		
	if action.return_to_origin:
		tween.tween_callback(func(): _return_obstacle_to_origin(obstacle, action))\
			.set_delay(action.return_delay)


func _return_obstacle_to_origin(obstacle: Node3D, action: ObstacleAction):
	if initial_positions.has(obstacle):
		var origin_position = initial_positions[obstacle]
		var tween = get_tree().create_tween()
		tween.tween_property(obstacle, "position", origin_position, action.return_duration)\
			.set_ease(action.return_ease_type_int as Tween.EaseType)\
			.set_trans(action.return_transition_type_int as Tween.TransitionType)
		
		# 当归位动画完成后，才重置 triggered 状态
		# 确保所有障碍物的归位动画都完成，这需要一个计数器。
		# 但为简化起见，这里假设每个障碍物的归位动作是独立的，并且一旦开始归位，管理器就允许再次触发。
		# 更严谨的做法是在 _execute_actions 之前设置一个计数器，所有归位 Tween 完成后才递减，递减到0时重置 triggered。
		# 但这会增加复杂性。目前这种实现，只要有归位动作，且不禁用管理器，就可以重复触发。
		if not disable_after_trigger:
			# 为了确保 triggered 状态在归位动画结束后才重置，我们把重置逻辑放到归位 Tween 的回调里
			tween.tween_callback(func():
				# 检查是否所有障碍物都完成了归位，这需要一个更复杂的机制
				# 简单处理：只要一个障碍物完成归位，就允许再次触发，或者在最后一个障碍物完成归位时触发
				# 考虑到当前简化设计，我们在这里不做复杂的计数，假设只要开始归位，就可以再次触发
				# 如果需要严格的“所有障碍物归位后才可再次触发”，请告诉我，需要修改逻辑
				triggered = false
			)
	else:
		print_rich("[color=red]错误：[/color] 无法找到障碍物 %s 的初始位置进行归位。" % obstacle.name)


func reset_all_obstacles_to_origin():
	for obstacle in managed_obstacles:
		if initial_positions.has(obstacle):
			# 确保在重置时停止所有正在进行的 Tween
			if obstacle.has_meta("active_tween"):
				var active_tween = obstacle.get_meta("active_tween")
				if active_tween and active_tween.is_valid():
					active_tween.kill()
				obstacle.remove_meta("active_tween")
			obstacle.position = initial_positions[obstacle] # 立即归位，没有动画
	
	triggered = false
	if trigger_area and disable_after_trigger:
		trigger_area.monitoring = true
