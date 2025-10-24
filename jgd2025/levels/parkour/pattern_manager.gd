# StripePatternManager.gd
extends Node3D

# --- 在检查器中设置你的模式 ---

# 1. 这个管理器控制哪一个“组”的方块？
@export var controlled_group: String = "runway_group_1"

# 2. 跑道是沿着哪个轴延伸的？ ( "X" 或 "Z" )
@export var drop_axis: String = "Z"

# 3. 跑道是朝正方向(1)还是负方向(-1)延伸的？
@export var drop_direction: int = 1

# 4. 【频率】每一排方块下降的*总*间隔时间
@export var row_drop_interval: float = 0.5

# 5. 奇偶列之间的间隔时间（制造条纹效果）
@export var stripe_delay: float = 0.1

# 6. 方块掉下去后，保持多久才“重置”？
@export var row_reset_delay: float = 3.0

# 7. (可选) 跑道是否循环？
@export var loop: bool = false

# 8. 【新】初始延迟：过几秒后才开始第一轮下降
@export var initial_delay: float = 0.0


# --- 内部变量 ---
@onready var pattern_timer = $PatternTimer

# 存储所有排序后的“排”
var sorted_rows: Array = []
var current_row_index: int = 0
var column_axis_index: int = 0 # 0=X, 1=Y, 2=Z


func _ready():
	# 1. 设置计时器
	pattern_timer.wait_time = row_drop_interval
	pattern_timer.timeout.connect(_on_pattern_timer_timeout)
	
	# 2. 找到并排序所有方块
	await get_tree().process_frame
	
	var nodes = get_tree().get_nodes_in_group(controlled_group)
	if nodes.is_empty():
		print_rich("[color=yellow]警告：[/color]PatternManager 找不到任何在 '%s' 组里的 ParkourBlock。" % controlled_group)
		return

	# --- 核心排序逻辑 ---
	var rows_dict: Dictionary = {}
	var axis_index = 0 # 0=X, 1=Y, 2=Z
	
	if drop_axis.to_upper() == "X":
		axis_index = 0
		column_axis_index = 2 # 如果跑道是X轴，那列就是Z轴
	else:
		axis_index = 2
		column_axis_index = 0 # 如果跑道是Z轴，那列就是X轴
	
	for node in nodes:
		if node is ParkourBlock:
			var coord = node.global_position[axis_index]
			var snapped_coord = roundi(coord)
			
			if not rows_dict.has(snapped_coord):
				rows_dict[snapped_coord] = []
			rows_dict[snapped_coord].append(node)

	var row_coords = rows_dict.keys()
	if drop_direction > 0:
		row_coords.sort() # 升序
	else:
		row_coords.sort_custom(func(a, b): return a > b) # 降序
		
	for coord in row_coords:
		sorted_rows.append(rows_dict[coord])
	# --- 排序结束 ---

	# --- **关键改动** ---
	# 4. 启动模式！
	if not sorted_rows.is_empty():
		if initial_delay > 0.0:
			# 如果设置了初始延迟，就等待
			get_tree().create_timer(initial_delay).timeout.connect(_start_pattern)
		else:
			pass
			# 否则，等待
			#_start_pattern()
	# --- **结束改动** ---


# 这是一个新的辅助函数，用来启动主计时器
func _start_pattern():
	print("Initial delay finished. Starting pattern.")
	pattern_timer.start()


# 计时器触发！下降下一排
func _on_pattern_timer_timeout():
	
	# 检查是否还有“排”可以下降
	if current_row_index >= sorted_rows.size():
		if loop:
			current_row_index = 0 # 如果循环，就重头开始
		else:
			pattern_timer.stop() # 否则，停止计时器
			return
	
	# 1. 获取当前要下降的那一排
	var row_to_drop: Array = sorted_rows[current_row_index]
	
	# --- 新的“条纹”逻辑 ---
	var odd_blocks: Array = []
	var even_blocks: Array = []
	
	# 2. 把这一排的方块分成“奇数列”和“偶数列”
	for block in row_to_drop:
		var col_coord = roundi(block.global_position[column_axis_index])
		if col_coord % 2 == 0:
			even_blocks.append(block)
		else:
			odd_blocks.append(block)

	# 3. 首先，下降所有“奇数”方块
	for block in odd_blocks:
		if not block.collision_shape.disabled:
			block.drop()
			get_tree().create_timer(row_reset_delay).timeout.connect(block.reset)
	
	# 4. 等待
	if even_blocks.size() > 0 and stripe_delay > 0.0:
		await get_tree().create_timer(stripe_delay).timeout

	# 5. 然后，下降所有“偶数”方块
	for block in even_blocks:
		if not block.collision_shape.disabled:
			block.drop()
			get_tree().create_timer(row_reset_delay + stripe_delay).timeout.connect(block.reset)
	# --- 条纹逻辑结束 ---

	# 6. 准备下降下一排
	current_row_index += 1
