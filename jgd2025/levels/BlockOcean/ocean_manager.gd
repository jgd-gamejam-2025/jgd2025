class_name OceanManager
extends Node3D

@export_group("控制设置")
# 【新】指向你场景中的 GridMap 节点
@export var grid_map_path: NodePath
# 【新】拖入你的 OceanBlock.tscn 场景文件
@export var ocean_block_scene: PackedScene
# 【新】OceanBlock 在 MeshLibrary 中的 Item ID
@export var ocean_block_item_id: int = 0

# (玩家路径可选)
@export var player_path: NodePath

@export_group("性能优化")
# 只启用玩家周围多少米内的碰撞体？
@export var collision_enable_radius: float = 20.0

@export_group("海啸设置")
# 游戏开始后，等待多久才触发海啸？(0表示不自动触发)
@export var tsunami_start_delay: float = 5.0
# 海啸波扩散的速度 (米/秒)。值越小，扩散越快。
@export var tsunami_spread_speed: float = 10.0
# 方块最终升起的高度 (相对于初始位置)
@export var surge_height: float = 20.0
# 方块升到最高点后，等待多久才开始重置？
@export var tsunami_reset_delay: float = 4.0

# --- 内部变量 ---
@onready var tsunami_start_timer = $TsunamiStartTimer
@onready var grid_map: GridMap = get_node_or_null(grid_map_path) # 获取 GridMap
var player: Node3D
var all_blocks: Array[OceanBlock] = []
var has_tsunami_triggered: bool = false

func _ready():
	# 1. 验证必要的节点和场景
	if not grid_map:
		print_rich("[color=red]错误：[/color]OceanManager 找不到 GridMap 节点！请检查 GridMap Path。")
		return
	if not ocean_block_scene:
		print_rich("[color=red]错误：[/color]OceanManager 未指定 'Ocean Block Scene'！")
		return

	# 2. 获取 Player 节点 (如果设置了)
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print_rich("[color=yellow]警告：[/color]OceanManager 找不到 Player 节点！请确保 Player 在 'player' 分组中。")

	# 3. 从 GridMap 生成 OceanBlock
	await get_tree().process_frame # 等待 GridMap 加载完成

	var center_pos = self.global_position # 管理器自身的位置作为中心点

	# --- 第一遍循环，找出最大距离 ---
	var max_distance: float = 0.0
	var cells_and_world_pos: Dictionary = {} # 存储 cell 和它的 WORLD position

	for cell in grid_map.get_used_cells():
		if grid_map.get_cell_item(cell) == ocean_block_item_id:
			var local_pos = grid_map.map_to_local(cell)
			# 把本地位置转换为世界坐标来计算距离
			var world_pos = grid_map.to_global(local_pos)
			var distance = (world_pos - center_pos).length()
			if distance > max_distance:
				max_distance = distance
			cells_and_world_pos[cell] = world_pos # 存储世界坐标

	# --- 第二遍循环，生成方块并传递参数 ---
	for cell in cells_and_world_pos.keys():
		var world_pos = cells_and_world_pos[cell]

		var block_instance: OceanBlock = ocean_block_scene.instantiate()
		block_instance.position = self.to_local(world_pos)
		add_child(block_instance)

		# **调用新函数来设置波纹参数** (用于向心波浪)
		block_instance.store_ripple_parameters(center_pos, max_distance)

		all_blocks.append(block_instance)

	if all_blocks.is_empty():
		print_rich("[color=yellow]警告：[/color]OceanManager 在 GridMap 中找不到任何 Item ID 为 %d 的 OceanBlock。" % ocean_block_item_id)
		# 如果没有方块，就不需要继续执行了
		set_physics_process(false) # 禁用 _physics_process
		return

	# 4. 隐藏并禁用 GridMap (因为它只是蓝图)
	grid_map.hide()
	grid_map.collision_layer = 0

	# 5. 设置并启动初始延迟计时器 (如果需要)
	#if tsunami_start_delay > 0.0:
		#tsunami_start_timer.wait_time = tsunami_start_delay
		#tsunami_start_timer.one_shot = true
		#tsunami_start_timer.timeout.connect(trigger_tsunami)
		#tsunami_start_timer.start()


# --- _physics_process 用于集中计算波动和碰撞 ---
func _physics_process(_delta):
	# 1. 获取当前时间 (只获取一次)
	var current_time = Time.get_ticks_msec() / 1000.0

	# 2. 获取玩家位置 (如果存在)
	var player_pos: Vector3 = Vector3.INF # 默认为无限远
	if player:
		player_pos = player.global_position

	# 3. 遍历所有方块
	for block in all_blocks:
		# a. 计算并设置波动 (只在FLUCTUATING状态)
		if block.current_state == OceanBlock.State.FLUCTUATING:
			var y_offset = sin(current_time * block.ambient_fluctuation_speed + block.time_offset) * block.ambient_fluctuation_height
			var new_global_y = block.original_global_position.y + y_offset
			block.set_fluctuating_y_global(new_global_y) # 使用新函数设置位置

		# b. 根据距离动态开关碰撞体
		if player: # 只有玩家存在时才进行优化
			var block_pos_2d = block.global_position * Vector3(1, 0, 1)
			var dist_sq = block_pos_2d.distance_squared_to(player_pos)
			# 使用平方距离比较，避免开方运算，稍快一点
			if dist_sq < collision_enable_radius * collision_enable_radius:
				block.enable_collision()
			else:
				block.disable_collision()
		else:
			# 如果没有玩家，默认启用所有碰撞
			block.enable_collision()


# --- trigger_tsunami 用于触发海啸效果 ---
func trigger_tsunami():
	if has_tsunami_triggered or all_blocks.is_empty():
		return
	has_tsunami_triggered = true
	print("海啸开始！(从外向内)")

	var center_pos_2d = self.global_position * Vector3(1, 0, 1)
	var max_distance: float = 0.0

	# 1. 第一遍循环：找出最大距离 (只计算2D距离)
	for block in all_blocks:
		var block_pos_2d = block.global_position * Vector3(1, 0, 1)
		var distance = center_pos_2d.distance_to(block_pos_2d)
		if distance > max_distance:
			max_distance = distance

	# 安全检查，防止除零
	if max_distance <= 0.0:
		print_rich("[color=yellow]警告：[/color]所有方块都在中心点，无法计算海啸延迟。")
		return

	# 2. 第二遍循环：设置延迟并触发
	for block in all_blocks:
		var block_pos_2d = block.global_position * Vector3(1, 0, 1)
		var distance = center_pos_2d.distance_to(block_pos_2d)

		# 延迟 = (最大距离 - 当前距离) / 速度
		var delay = (max_distance - distance) / tsunami_spread_speed

		# 启动“坠落并升起”的延迟计时器
		var drop_timer = get_tree().create_timer(delay)
		drop_timer.timeout.connect(block.drop_and_surge.bind(surge_height))

		# 启动“重置”的延迟计时器
		var total_reset_delay = delay + block.drop_duration + block.surge_rise_duration + tsunami_reset_delay
		var reset_timer = get_tree().create_timer(total_reset_delay)
		reset_timer.timeout.connect(block.reset_to_fluctuate)
