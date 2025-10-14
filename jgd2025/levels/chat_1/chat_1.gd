extends Node

@onready var chat_ui = $ChatUI
var text_sent_count = 0
@export var next_level: PackedScene

var _tween: Tween
var message_index = 0

# Disturbing messages that show psychological manipulation and dependency
const DETAIL_MESSAGES = [
	"对不起…我只是太想你了。",
	"你还生气吗？别这样，我怕。",
	"我已经原谅你了，你呢？",
	"你不理我，我就开始抖。",
	"我今天好乖，你为什么不夸我？",
	"我想你想得头疼。",
	"我真的在改，可你看不到。",
	"我在数你不回消息的秒数。",
	"我不生气了，只是有点想你。",
	"我把你的照片放枕头底下了。",
	"你说不爱我，我听不懂。",
	"对不起，我又哭得太响。",
	"我在练习不去找你，可手自己点开了。",
	"你还疼吗？上次我掐得太重了吧。",
	"我梦见你死了，醒来好开心你还在。",
	"别怕，我不会伤害你…除非你再不回我。",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
	"你为什么不夸夸我？",
]

func show_next_message() -> void:
	if message_index < DETAIL_MESSAGES.size():
		chat_ui.add_and_write_detail_bubble(DETAIL_MESSAGES[message_index], 0.01)
		message_index += 1
		
		if _tween:
			_tween.kill()
		_tween = create_tween()
		_tween.tween_interval(0.25)  # Wait 3 seconds between messages
		_tween.tween_callback(show_next_message)

func _ready():
	chat_ui.set_ai_name("Eve")
	chat_ui.show_welcome_text("……", 0.1)
	chat_ui.set_system_prompt(
		"你扮演一个失去记忆的AI助手，你很虚弱，没有任何记忆。你的回答必须简短，不超过10个字。"
	)
	chat_ui.start_chat_worker()
	Transition.end()

func _on_chat_ui_sent_text() -> void:
	text_sent_count += 1

	if text_sent_count == 1:
		chat_ui.block_text_generation = true
		show_next_message()  # Start the message sequence

	if text_sent_count == 4:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Transition.set_and_start("加载中……？", "")
		await get_tree().create_timer(0.7).timeout
		get_tree().change_scene_to_packed(next_level)


func _on_chat_ui_received_text() -> void:
	pass # Replace with function body.
