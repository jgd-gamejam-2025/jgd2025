# FluctuatingBlock.gd
extends AnimatableBody3D

@export_group("波动效果")
# 方块上下波动的最大高度（米）
@export var fluctuation_height: float = 1.0
# 波动速度（值越大，波动越快）
@export var fluctuation_speed: float = 1.0

@export_group("波动偏移")
# 设为 true，方块会根据它在世界中的位置来错开波动，形成漂亮的波浪效果
# 设为 false，每个方块会随机错开，看起来比较混乱
@export var use_position_offset: bool = true
# 波浪的“疏密”程度（值越大，波浪越密集）
@export var position_offset_multiplier: float = 0.5

# 内部变量
var time_offset: float = 0.0
var original_y: float

func _ready():
	# 记住方块的初始 Y 坐标
	original_y = self.position.y
	
	if use_position_offset:
		# 【波浪效果】根据方块的 X 和 Z 坐标计算一个固定的时间偏移
		# 这样，位置相近的方块，它们的动画也相近
		time_offset = (self.global_position.x + self.global_position.z) * position_offset_multiplier
	else:
		# 【随机效果】给每个方块一个完全随机的起始时间点
		time_offset = randf_range(0, 2 * PI)

func _physics_process(delta):
	# 1. 获取一个持续增长的时间值
	var current_time = Time.get_ticks_msec() / 1000.0
	
	# 2. 使用 sin 函数来计算 Y 轴的偏移
	# sin() 的结果会在 [-1, 1] 之间平滑地来回摆动
	var y_offset = sin(current_time * fluctuation_speed + time_offset) * fluctuation_height
	
	# 3. 将计算出的偏移应用到方块的 Y 坐标上
	var new_position = self.position
	new_position.y = original_y + y_offset
	self.position = new_position
