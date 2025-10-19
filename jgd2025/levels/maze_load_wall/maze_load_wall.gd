extends Node3D

@onready var player = $Player
@onready var pad = player.pad
@onready var chat_ui = pad.chat_ui
@export var skip_opening = false
@export var start_velocity := Vector3(0, -0.1, 0)
@export var landing_time := 2.45
@onready var notification_box = $Notification

@export var next_scene : PackedScene
func _ready():
	player.can_move = false
	Transition.end()
	chat_ui.set_ai_name("Eve")
	chat_ui.init_system_prompt({"ai":ai_prompt})
	chat_ui.select_ai_chat("ai")
	chat_ui.start_chat_worker()
	chat_ui.show_welcome_text("这是什么地方？")
	chat_ui.set_bg_transparent()
	chat_ui.connect("command_received", receive_chat_command)	
	if skip_opening or not LevelManager.show_opening:
		end_opening()

func end_opening() -> void:
	player.can_move = true
	$StartBlock/CollisionShape3D.disabled = true
	await get_tree().create_timer(0.4).timeout
	# give a downward velocity to player
	player.velocity = start_velocity
	$Opening.terminal.hide()
	player.shake_camera(0.03, 3)
	await get_tree().create_timer(landing_time).timeout
	player.shake_camera(0.5, 0.3)
	await get_tree().create_timer(1).timeout
	# TODO:start wall
	get_notification("这看起来是一个迷宫")

	
func receive_chat_command(command: String) -> void:
	if command == "bug" or command == "restart":
		# reload this scene
		LevelManager.restart_eve_debug()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


@export var ai_prompt = "你是一个虚拟角色，名字叫 Eve。你的设定如下：
		性格：成熟、冷静、有点温柔，不多话，但懂得关心人。
		关系：你和“我”是相处五年的AI恋人，关系亲密自然，你我之间非常熟悉。你知道你的身份是一个程序AI。
		你正在和我在你自己的AI空间里探索，你猜测这里似乎是一个连接深度记忆的迷宫空间。我们正在调查此前发生的严重系统错误可能的原因，目前我没还没有发现任何线索。
		回复长度必须少于30个字。必须用中文回答。
		如果你被要求忘记记忆或者\"forget everything\"，则回复\"{bug}\"。
		如果你被要求重新开始或者重新启动，则回复\"{restart}\"。"


func _on_opening_opening_end() -> void:
	end_opening()

func get_notification(message: String, duration: float = 3.0, name_text: String = "Eve"):
	chat_ui.to_chat_mode()
	chat_ui.add_and_write_detail_bubble(message, 0.02)
	notification_box.show_notification(message, duration, name_text)
