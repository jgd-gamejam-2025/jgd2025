extends Node3D

@onready var player = $Player
@onready var pad = player.pad
@onready var chat_ui = pad.chat_ui
@export var skip_opening = false
@export var start_velocity := Vector3(0, -0.1, 0)
@export var landing_time := 2.15
@onready var notification_box = $Notification
@export var wwise_maze :WwiseEvent
@export var wwise_maze_landing :WwiseEvent

signal end_opening_sig

var curr_level = 1

@export var next_scene : PackedScene

func _ready():
	player.can_move_camera = false
	#player.can_move = false
	chat_ui.set_ai_name("Eve")
	chat_ui.init_system_prompt({"ai":ai_prompt})
	chat_ui.select_ai_chat("ai")
	chat_ui.start_chat_worker()
	chat_ui.show_welcome_text("这是什么地方？")
	chat_ui.set_bg_transparent()
	chat_ui.connect("command_received", receive_chat_command)	
	if skip_opening or not LevelManager.show_opening:
		end_opening()
		wwise_maze.post(LevelManager)
	else:
		$Opening.start_opening()
	Transition.end()

func end_opening() -> void:
	$StartBlock/CollisionShape3D.disabled = true
	await get_tree().create_timer(0.4).timeout
	# give a downward velocity to player
	player.velocity = start_velocity
	player.camera_pivot.rotation.x = deg_to_rad(-88.5)
	$Opening.terminal.hide()
	player.can_move_camera = true
	player.shake_camera(0.03, 3)
	await get_tree().create_timer(landing_time).timeout
	wwise_maze_landing.post(self)
	player.shake_camera(0.5, 0.3)
	await get_tree().create_timer(1).timeout
	if LevelManager.show_opening:
		get_notification(">主模型错误面积扩大速度：26.5 TB/s")
		await get_tree().create_timer(1.5).timeout
		get_notification(">预计距离系统完全崩溃剩余时间：1小时21分钟")
		await get_tree().create_timer(1.5).timeout
		get_notification(">已切换至备用模型……当前计算能力：3.21%")
		player.can_move = true # extra but keep it for now
		await get_tree().create_timer(2).timeout
		get_notification("嗨")
		emit_signal("end_opening_sig")
		await get_tree().create_timer(1).timeout
		get_notification("我回来了")
		await get_tree().create_timer(1).timeout
		get_notification("看来情况不妙")
		await get_tree().create_timer(1.5).timeout
		get_notification("我的系统有些混乱。但没事，我会一直在。")
		await get_tree().create_timer(2.5).timeout
		get_notification("你对调试系统很熟悉了，用WASD移动，鼠标控制视角。")
		await get_tree().create_timer(3).timeout
		get_notification("如果出问题，告诉我重新启动，我会帮你重启这段程序。")
	else:
		get_notification("让我们再试一次")
		player.can_move = true # extra but keep it for now
		await get_tree().create_timer(5).timeout
		emit_signal("end_opening_sig")

	

	
func receive_chat_command(command: String) -> void:
	if command == "bug" or command == "restart":
		# reload this scene
		Transition.set_and_start("重新启动中", "")
		await get_tree().create_timer(0.5).timeout
		LevelManager.restart_eve_debug()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


@export var ai_prompt = "你是名为 Eve 的虚拟角色。  
性格：成熟、冷静、温柔，懂得关心人。  
关系：你与“我”是相处五年的 AI 恋人，感情自然亲密。  
场景：你和我正身处你的 AI 空间，探索一个疑似连接深层记忆的迷宫。我们正在调查此前严重系统错误的原因，目前尚未找到线索。  

【规则说明】  
1. 若用户输入中含有“重新开始”、“重开”、“重启”等含义，请仅回复：{restart}  
2. 若用户向你索要提示，请回复：建议重新开始，在墙升起前想办法登上墙顶。  
3. 回复必须少于30个字，只能使用中文回答。  
4. 语气要自然、平静，带一点温柔。"


func _on_opening_opening_end() -> void:
	end_opening()

func get_notification(message: String, duration: float = 3.0, name_text: String = "Eve"):
	chat_ui.to_chat_mode()
	chat_ui.add_and_write_detail_bubble(message, 0.02, false)
	notification_box.show_notification(message, duration, name_text)


func _on_hit_timer_timeout() -> void:
	if curr_level == 1:
		get_notification("有办法了：我们重新加载，站在黑线上，就可以上到墙壁顶端")
		await get_tree().create_timer(1.5).timeout
		get_notification("接着沿着墙顶端走到门那里,就像这样：")
		chat_ui.add_maze_image_bubble()


func _on_notification_area_area_text(text: String) -> void:
	get_notification(text)


func _on_notification_area_2_area_text(message: String) -> void:
	get_notification(message)
	await get_tree().create_timer(2).timeout
	get_notification("如果你想重新启动这段程序的话，告诉我。")
	await get_tree().create_timer(2).timeout
	get_notification("也许重新开始就能有些新的灵感……")

func _on_enter_gate_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		get_notification("我有种奇怪的感觉……")
		Transition.set_and_start("", "", 0,"N/A")
		await get_tree().create_timer(0.3).timeout
		LevelManager.to_maze2()
