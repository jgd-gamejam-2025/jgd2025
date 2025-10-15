# MazeManager.gd
extends Node3D

# 在检查器中拖入 wall.tscn 场景文件
@export var wall_scene: PackedScene
# 墙体的高度
@export var wall_height = 4.0
# 玩家节点的路径，在检查器中指定
@export var player_path: NodePath

@onready var grid_map = $GridMap
@onready var rise_timer = $RiseTimer
@onready var player = get_node(player_path)

# 一个标志位，防止重复触发
var maze_has_risen = false
# 一个标志位，表示玩家已经落地
var player_has_landed = false

func _ready():
	# 确保有墙体场景被指定
	if not wall_scene:
		print_rich("[color=red]错误：[/color]MazeManager 未指定 Wall Scene！")
		return
		
	# 1. 根据 GridMap 生成独立的墙体
	# 遍历 GridMap 中所有被“画”了的格子
	for cell in grid_map.get_used_cells():
		# 实例化一个墙体
		var wall_instance = wall_scene.instantiate()
		
		# --- THIS IS THE CORRECTED PART ---
		# 获取格子相对于GridMap的局部位置
		var local_pos = grid_map.map_to_local(cell)
		wall_instance.position = local_pos
		# --- END OF CORRECTION ---
		
		# 2. 将墙体“藏”入地下，使其顶部与 y=0 的地面平齐
		# 注意：这里假设墙体模型的原点在中心，所以要减去一半高度
		wall_instance.position.y -= (wall_height / 2.0)
		
		add_child(wall_instance)
		# 3. 将所有墙体添加到一个分组，方便之后统一操作
		wall_instance.add_to_group("walls")
		
	# 4. 隐藏原始的 GridMap，因为它只是用来设计的
	grid_map.hide()


func _process(_delta):
	# 检查玩家是否落地，并且迷宫还未升起
	if not maze_has_risen and not player_has_landed and player.is_on_floor():
		player_has_landed = true
		print("玩家已落地，启动计时器！")
		# 玩家落地后，启动计时器
		rise_timer.start()


# 当 RiseTimer 计时结束时，这个函数会被调用 (通过信号连接)
func _on_rise_timer_timeout():
	print("计时结束，迷宫升起！")
	raise_maze()


func raise_maze():
	# 如果已经升起，就直接返回
	if maze_has_risen:
		return
	maze_has_risen = true
	
	# 检查玩家当前是否在某个墙体的顶部
	var player_is_on_wall = _is_player_on_wall_top()
	
	# 创建一个 Tween 动画控制器
	var tween = create_tween()
	# 设置为并行，让所有墙和玩家的动画同时播放
	tween.set_parallel(true)
	
	# 遍历 "walls" 分组中的所有墙体
	for wall in get_tree().get_nodes_in_group("walls"):
		# 目标Y坐标 = 当前Y坐标 + 墙体高度
		var target_y = wall.position.y + wall_height
		# 添加一个动画：在2.5秒内将墙体的 position:y 属性变化到 target_y
		tween.tween_property(wall, "position:y", target_y, 2.5).set_ease(Tween.EASE_OUT_IN)

	# 如果玩家在墙顶上，也要让他同步上升
	if player_is_on_wall:
		print("玩家在墙顶上，将随墙体一起上升。")
		var player_target_y = player.global_position.y + wall_height
		# 注意：这里我们动画的是 global_position，因为玩家节点不在 MazeManager 之下
		tween.tween_property(player, "global_position:y", player_target_y, 2.5).set_ease(Tween.EASE_OUT_IN)


# 使用向下射线检测来判断玩家是否在墙顶
func _is_player_on_wall_top():
	# 获取物理世界的直接状态
	var space_state = get_world_3d().direct_space_state
	
	# 设置射线查询的参数：从玩家位置开始，向下发射一小段距离 (例如1米)
	var query = PhysicsRayQueryParameters3D.create(player.global_position, player.global_position + Vector3.DOWN * 1.0)
	# 排除玩家自身，防止射线打到自己
	query.exclude = [player]
	
	var result = space_state.intersect_ray(query)
	
	# 如果射线碰到了东西
	if result:
		# 检查碰到的是不是一个 "walls" 分组里的成员
		if result.collider.is_in_group("walls"):
			return true
			
	return false
