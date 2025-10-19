# MazeManager.gd
extends Node3D

# ... (wall_scene, decal_pattern_scene 保持不变) ...
@export var wall_scene: PackedScene
@export var decal_pattern_scene: PackedScene

@export var wall_height = 15.0
@export var player_path: NodePath
@export var wall_rise_time = 2.5
# 每个墙体之间开始升起的间隔时间（秒）
@export var ripple_delay = 0.05
# 每次波纹同时升起几块墙
@export_range(1, 100, 1) var ripple_batch_size: int = 1

@onready var grid_map = $GridMap
@onready var rise_timer = $RiseTimer
@onready var player = get_node(player_path)

var maze_has_risen = false
var player_has_landed = false
var wall_to_decal_map = {}


func _ready():
	# ... (这个函数完全保持不变) ...
	if not wall_scene or not decal_pattern_scene:
		print_rich("[color=red]错误：[/color]MazeManager 未指定 Wall Scene 或 Decal Pattern Scene！")
		return
		
	for cell in grid_map.get_used_cells():
		var local_pos = grid_map.map_to_local(cell)
		
		# --- 1. 创建墙体 (带碰撞，但隐藏) ---
		var wall_instance = wall_scene.instantiate()
		wall_instance.position = local_pos
		wall_instance.position.y = - (wall_height / 2.0)
		wall_instance.hide()
		add_child(wall_instance)
		wall_instance.add_to_group("walls")
		
		# --- 2. 创建 Decal 图案 (纯视觉，可见) ---
		var decal_instance = decal_pattern_scene.instantiate()
		decal_instance.position = local_pos
		decal_instance.position.y = 1.0
		add_child(decal_instance)
		
		# --- 3. 存储它们的对应关系 ---
		wall_to_decal_map[wall_instance.get_instance_id()] = decal_instance
		
	grid_map.hide()


func _process(_delta):
	# ... (这个函数完全保持不变) ...
	if not maze_has_risen and not player_has_landed and player.is_on_floor():
		player_has_landed = true
		print("玩家已落地，启动计时器！")
		rise_timer.start()


func _on_rise_timer_timeout():
	# ... (这个函数完全保持不变) ...
	print("计时结束，迷宫升起！")
	raise_maze()


# --- 这是被重写的 raise_maze 函数 ---
func raise_maze():
	if maze_has_risen:
		return
	maze_has_risen = true
	
	# 1. 获取所有墙体
	var walls = get_tree().get_nodes_in_group("walls")
	
	# 2. 根据离玩家的距离对墙体进行排序
	walls.sort_custom(_sort_walls_by_distance)
	
	# 3. 检查玩家是否在墙上
	var wall_player_is_on = _is_player_on_wall_top() # 这个函数现在返回一个Node
	
	var tween = create_tween()
	tween.set_parallel(true) # 动画是并行的，但我们会用 delay 错开
	
	# --- 新增代码 ---
	# 确保 batch_size 至少为1，防止除零错误
	var batch_size = max(1, ripple_batch_size)
	# --- 结束新增 ---
	
	# 4. 遍历排序后的墙体列表
	for i in range(walls.size()):
		var wall = walls[i]
		
		# 5. --- 修改此行 ---
		# 计算每个墙体的延迟时间 (使用批量计算)
		var calculated_delay = (i / batch_size) * ripple_delay
		
		# 6. 隐藏对应的 Decal
		var decal = wall_to_decal_map.get(wall.get_instance_id())
		if decal:
			tween.tween_callback(decal.hide).set_delay(calculated_delay)
			
		# 7. 显示墙体
		tween.tween_callback(wall.show).set_delay(calculated_delay)
		
		# 8. 动画墙体位置
		var target_y = wall.position.y + wall_height
		tween.tween_property(wall, "position:y", target_y, wall_rise_time).set_delay(calculated_delay).set_ease(Tween.EASE_OUT_IN)

	# 9. (新) 处理玩家的上升
	if wall_player_is_on:
		print("玩家在墙顶上，将随墙体一起上升。")
		
		# 找到玩家所在墙体的索引，以获取正确的延迟
		var player_wall_index = walls.find(wall_player_is_on)
		var player_delay = 0.0
		
		if player_wall_index != -1:
			# --- 修改此行 ---
			# 玩家的延迟也使用批量计算
			player_delay = (player_wall_index / batch_size) * ripple_delay
			
		var player_target_y = player.global_position.y + wall_height
		# 使用和墙体相同的延迟来动画玩家
		tween.tween_property(player, "global_position:y", player_target_y, wall_rise_time).set_delay(player_delay).set_ease(Tween.EASE_OUT_IN)

# --- 这是一个新的辅助函数 ---
# 用于排序的自定义比较函数
func _sort_walls_by_distance(wall_a, wall_b):
	# 我们只比较 xz 平面上的距离，忽略高度
	var player_pos_2d = player.global_position * Vector3(1, 0, 1)
	var dist_a = (wall_a.global_position * Vector3(1, 0, 1)).distance_to(player_pos_2d)
	var dist_b = (wall_b.global_position * Vector3(1, 0, 1)).distance_to(player_pos_2d)
	
	# 返回 true 表示 a 应该排在 b 前面
	return dist_a < dist_b


# --- 这是被修改的 _is_player_on_wall_top 函数 ---
# (它现在返回 Node 或 null)
func _is_player_on_wall_top() -> Node:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(player.global_position, player.global_position + Vector3.DOWN * 1.0)
	query.exclude = [player]
	
	var result = space_state.intersect_ray(query)
	if result:
		# 检查碰到的是不是一个 "walls" 分组里的成员
		if result.collider.is_in_group("walls"):
			return result.collider # 返回它碰到的那个墙体
			
	return null # 没有碰到墙体
