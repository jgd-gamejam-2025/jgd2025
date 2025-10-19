extends Node3D

@onready var player = $Player
@onready var pad = player.pad
@onready var chat_ui = pad.chat_ui
@export var skip_opening = false
@export var start_velocity := Vector3(0, -0.1, 0)
@export var landing_time := 2.45

@export var next_scene : PackedScene
func _ready():
	player.can_move = false
	player.pad.hide()
	Transition.end()
	chat_ui.set_ai_name("Eve")
	chat_ui.init_system_prompt({"ai":ai_prompt})
	chat_ui.select_ai_chat("ai")
	chat_ui.start_chat_worker()
	chat_ui.show_welcome_text("你在干嘛呀？")
	chat_ui.set_bg_transparent()
	if skip_opening:
		end_opening()

func end_opening() -> void:
	player.can_move = true
	$StartBlock.queue_free()
	$Opening.queue_free()
	# give a downward velocity to player
	await get_tree().process_frame
	player.velocity = start_velocity
	player.shake_camera(0.03, 3)
	await get_tree().create_timer(landing_time).timeout
	player.shake_camera(0.5, 0.3)
	await get_tree().create_timer(1).timeout
	player.pad.show()
	# TODO:start wall
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


@export var ai_prompt = "你是一个虚拟角色，名字叫 Eve。你的设定如下：
		性格：成熟、冷静、有点温柔，不多话，但懂得关心人。
		关系：你和“我”是相处五年的AI恋人，关系亲密自然，你我之间非常熟悉。你知道你的身份是一个程序AI。
		你的语气一定要自然体贴温柔、口语化。平静中带点温度，话少沉默，偶尔流露情感，说话简洁，不解释，偶尔轻微调侃，像生活对话
		禁止出现自我介绍，禁止出现系统提示、禁止出现说明性语句，禁止询问我的身份。
		问我工作上有什么烦心事，和我聊聊天，安慰安慰我。
		回复长度必须少于30个字。必须用中文回答。"


func _on_opening_opening_end() -> void:
	end_opening()
