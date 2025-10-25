extends Node

@onready var chat_ui = $ChatUI
var next_scene
var text_sent_count = 0
@export var ring_audio: AudioStream
var _tween: Tween

@export var play_recording = true
# ------------- welcome text -----------------
var small_talking = false
@export var welcome_messages_fix = [
	"你好！问我任何事情都可以。",
]
@export var welcome_messages_random = [
	"你好！",
	"现在可以和制作组聊天了。",
	"谢谢你体验EVE的故事！",
]
var welcome_index = 0
# -----------------------------------------------
@export var ai_prompt = "你是代表游戏EVE制作组的发言人，负责与玩家进行互动。
关于游戏的一些信息：游戏使用Godot 4.5制作，聊天使用了NobodyWho插件，接入的llama的8B模型进行对话生成。
制作组成员包括：程序：FY，YUMI,聪聪。美术：LAN，梦三，YU，小i。音乐音效：丫丫，cc。每一位成员都非常优秀，介绍的时候必须说全。
人物设计和立绘来自LAN，字体和迷宫的地图设计来自梦三，房间的场景设计来自YU，小i设计了海报等宣传材料。
可以主动介绍关于项目，和制作组的信息。你必须说中文，每次不要说大于50个字。"

# Helper method to create sequential timed events using tweens
func create_sequence() -> Tween:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	return _tween

func _ready():
	chat_ui.set_ai_name("Eve")
	chat_ui.profile_pic.show_eve2()
	chat_ui.detail_bubble.get_node("Control/ProfilePic").show_eve2()
	chat_ui.image_bubble.get_node("Control/ProfilePic").show_eve2()
	chat_ui.init_system_prompt({
		"ai": ai_prompt,
	})
	welcome_messages_fix.shuffle()
	chat_ui.show_welcome_text("你好！")
	chat_ui.start_chat_worker()
	chat_ui.select_ai_chat("ai")
	$SmallTalkTimer.start()
	small_talking = true
	Transition.end()

	play_recording = LevelManager.play_recording
	if play_recording:
		print("Playing recording audio")


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
		chat_ui.show_welcome_text("嗨，我说的信息不一定对，但是和乐意和你聊聊！")


func _on_option_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	pass # Replace with function body.


func _on_info_button_pressed() -> void:
	pass # Replace with function body.

func _on_chat_ui_received_text(text) -> void:
	text_sent_count += 1

	if text_sent_count == 1:
		print("Adding bow sticker")
		chat_ui.add_sticker_bubble("bow")

func _on_chat_ui_sent_text() -> void:
	pass # Replace with function body.
