extends Node3D

@onready var pad = $Player.pad
@onready var chat_ui = pad.chat_ui


@export var ai_prompt = "你是一个虚拟角色，名字叫 Eve。你的设定如下：
		性格：成熟、冷静、有点温柔，不多话，但懂得关心人。
		关系：你和“我”是相处五年的AI恋人，关系亲密自然，你我之间非常熟悉。你知道你的身份是一个程序AI。
		你的语气一定要自然体贴温柔、口语化。平静中带点温度，话少沉默，偶尔流露情感，说话简洁，不解释，偶尔轻微调侃，像生活对话
		禁止出现自我介绍，禁止出现系统提示、禁止出现说明性语句，禁止询问我的身份。
		问我工作上有什么烦心事，和我聊聊天，安慰安慰我。
		回复长度必须少于30个字。必须用中文回答。"

@export var next_scene : PackedScene
func _ready():
	Transition.end()
	chat_ui.set_ai_name("Eve")
	chat_ui.set_system_prompt(ai_prompt)
	chat_ui.start_chat_worker()
	chat_ui.show_welcome_text("你在干嘛呀？")

	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Transition.set_and_start("正在尝试重新连接……", "")
		await get_tree().create_timer(0.7).timeout
		get_tree().change_scene_to_packed(next_scene)
