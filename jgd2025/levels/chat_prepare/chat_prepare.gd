extends Node

@onready var chat_ui = $ChatUI
var next_scene
var text_sent_count = 0
@export var ring_audio: AudioStream
var _tween: Tween

# ------------- welcome text -----------------
var small_talking = false
@export var welcome_messages_fix = [
	"时间不早了，该休息了",
	"今天真累",
	"今天过得怎么样？",
	"有什么烦心事吗？",
]
@export var welcome_messages_random = [
	"你在想什么？",
	"怎么不说话？",
	"在忙吗？",
	"你在做啥？",
	"你在吗？",
]
var welcome_index = 0
# -----------------------------------------------
@export var ai_prompt = "你是一个虚拟角色，名字叫 Eve。你的设定如下：
		性格：成熟、冷静、有点温柔，不多话，但懂得关心人。
		关系：你和“我”是相处五年的AI恋人，关系亲密自然，你我之间非常熟悉。你知道你的身份是一个程序AI。
		你的语气一定要自然体贴温柔、口语化。平静中带点温度，话少沉默，偶尔流露情感，说话简洁，不解释，偶尔轻微调侃，像生活对话
		禁止出现自我介绍，禁止出现系统提示、禁止出现说明性语句，禁止询问我的身份。
		问我工作上有什么烦心事，和我聊聊天，安慰安慰我。
		回复长度必须少于30个字。必须用中文回答。"

# Helper method to create sequential timed events using tweens
func create_sequence() -> Tween:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	return _tween

func _ready():
	chat_ui.set_ai_name("Eve")
	chat_ui.set_system_prompt(ai_prompt)
	welcome_messages_fix.shuffle()
	chat_ui.show_welcome_text("嘿！")
	chat_ui.start_chat_worker()
	$SmallTalkTimer.start()
	small_talking = true

func _on_small_talk_timer_timeout() -> void:
	if small_talking:
		var message = ""
		if welcome_index < welcome_messages_fix.size():
			message = welcome_messages_fix[welcome_index]
			welcome_index = welcome_index + 1
		else:
			$SmallTalkTimer.wait_time = 10
			message = welcome_messages_random[randi() % welcome_messages_random.size()]
		chat_ui.show_welcome_text(message)


func _on_chat_ui_line_edit_focus() -> void:
	if small_talking:
		small_talking = false
		$SmallTalkTimer.stop()
		chat_ui.show_welcome_text("嗨，工作还顺利吗？")


func _on_option_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	pass # Replace with function body.


func _on_info_button_pressed() -> void:
	pass # Replace with function body.

func _on_chat_ui_received_text() -> void:
	text_sent_count += 1

	if text_sent_count == 2:
		next_scene = preload("res://levels/chat_bug/chat_bug.tscn")
		await get_tree().create_timer(0.7).timeout
		Transition.set_and_start("工作电话", "烦", 3.5, ring_audio)
		# wait for 4 seconds before showing the next text
		await get_tree().create_timer(3.5).timeout
		chat_ui.add_and_write_detail_bubble("电话？怎么了？")
	
	if text_sent_count == 4:
		Transition.set_and_start("该睡了", "困", 2.0)
		await get_tree().create_timer(2.0).timeout
		chat_ui.add_and_write_detail_bubble("时间不早了，你该休息了，说晚安吧？")

	if text_sent_count == 5:
		Transition.set_and_start("晚安。", "太困了 ", 4.0)
		await get_tree().create_timer(0.7).timeout
		get_tree().change_scene_to_packed(next_scene)

func _on_chat_ui_sent_text() -> void:
	pass # Replace with function body.
