# ObstacleAction.gd
extends Resource
class_name ObstacleAction

# 移动类型枚举 (不变)
enum MoveType {
	MOVE_NONE,
	MOVE_UP,
	MOVE_DOWN,
	MOVE_LEFT_X,    # X轴负方向
	MOVE_RIGHT_X,   # X轴正方向
	MOVE_FORWARD_Z, # Z轴负方向
	MOVE_BACKWARD_Z # Z轴正方向
}

@export var move_type: MoveType = MoveType.MOVE_UP
@export var move_distance: float = 3.0 # 移动的距离
@export var move_duration: float = 1.0 # 移动耗时（秒）

@export var ease_type_int: int = Tween.EASE_OUT # Tween.EaseType (0=Linear, 1=In, 2=Out, 3=InOut, 4=OutIn, 5=Sine, 6=Quad, 7=Cubic, 8=Quart, 9=Quint, 10=Expo, 11=Circ, 12=Elastic, 13=Back, 14=Bounce)
@export var transition_type_int: int = Tween.TRANS_SINE # Tween.TransitionType (0=Linear, 1=Sine, 2=Quad, 3=Cubic, 4=Quart, 5=6=7=8=Quint, 9=Expo, 10=Circ, 11=Elastic, 12=Back, 13=Bounce)


# --- 新增归位设置 ---
@export var return_to_origin: bool = false # 动作完成后是否归位？
@export var return_delay: float = 1.0      # 如果归位，延迟多久开始归位？
@export var return_duration: float = 0.5   # 归位动画耗时（秒）
@export var return_ease_type_int: int = Tween.EASE_IN_OUT # 归位时的缓动类型
@export var return_transition_type_int: int = Tween.TRANS_SINE # 归位时的过渡类型
