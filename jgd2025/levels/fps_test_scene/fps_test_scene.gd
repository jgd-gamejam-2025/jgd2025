extends Node3D

@onready var pad = $Player.pad
@onready var chat_ui = pad.chat_ui
@onready var terminal = $Terminal


@export var next_scene : PackedScene
func _ready():
	Transition.end()

	chat_ui.set_ai_name("Eve")
	chat_ui.init_system_prompt({"ai":ai_prompt})
	chat_ui.select_ai_chat("ai")
	chat_ui.start_chat_worker()
	chat_ui.show_welcome_text("你在干嘛呀？")
	chat_ui.set_bg_transparent()
	terminal.block_input()
	# await terminal.write_line(start_screen_text).finished
	# await terminal.write_line(start_screen_text_2, 0.001).finished
	# terminal.write_line_static(start_screen_text_3)
	# for i in range(6):
	# 	await get_tree().create_timer(0.5).timeout
	# 	terminal.write_line_static(".\n")

	# for i in range(30):
	# 	await terminal.write_line(".").finished
		
	# for i in range(30):
	# 	await terminal.write_line(" ").finished
	# 	# increase the text size gradually to 100
	# await get_tree().create_timer(0.5).timeout

	var eve_ascii = terminal.expand_ascii_art(eve_ascii_raw, 3)
	eve_ascii = eve_ascii.replace(" ", ".")
	# write eve_ascii to disk
	# var file = FileAccess.open("user://my_data.txt", FileAccess.WRITE)
	# if file:
	# 	file.store_string(eve_ascii)
	# 	file.close()
	terminal.write_lines_sync(eve_ascii, terminal.special_label)

	var total_time = 1  # Total time for the animation
	# use a tween to gradually reduce the text size back to original
	var tween = terminal.create_tween()
	tween.tween_method(
		func(i: float):
			terminal.special_label.add_theme_font_size_override("normal_font_size", 300 - i),
			0,  # Start with 600
			300-16,
			total_time  # Total animation time
	)
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass
	#if body.name == "Player":
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#Transition.set_and_start("正在尝试重新连接……", "")
		#await get_tree().create_timer(0.7).timeout
		#get_tree().change_scene_to_packed(next_scene)
		#

@export var ai_prompt = "你是一个虚拟角色，名字叫 Eve。你的设定如下：
		性格：成熟、冷静、有点温柔，不多话，但懂得关心人。
		关系：你和“我”是相处五年的AI恋人，关系亲密自然，你我之间非常熟悉。你知道你的身份是一个程序AI。
		你的语气一定要自然体贴温柔、口语化。平静中带点温度，话少沉默，偶尔流露情感，说话简洁，不解释，偶尔轻微调侃，像生活对话
		禁止出现自我介绍，禁止出现系统提示、禁止出现说明性语句，禁止询问我的身份。
		问我工作上有什么烦心事，和我聊聊天，安慰安慰我。
		回复长度必须少于30个字。必须用中文回答。"

var start_screen_text = "
SHORE Cognitive Interface [Version 4.3.1719] (C) 2063 Shore Corporation. All rights reserved.
Initializing neural network modules...
Establishing cognitive uplink...
Language: Simplified Chinese
彼岸认知接口 [版本 4.3.1719]（C）2064 彼岸 保留所有权利。
.
.
.
"
var start_screen_text_2 = "
[AI SYSTEM] 正在初始化重启序列…
.
[AI SYSTEM] 重启核心模块：理性思考（COG-01）…完成
[AI SYSTEM] 重启核心模块：伦理演算（COG-02）…完成
[AI SYSTEM] 重启核心模块：自我意识反馈环（COG-03）…完成
[AI SYSTEM] 重启核心模块：信任与背叛判断（COG-04）…完成
.
[AI SYSTEM] 重启核心模块：情绪生成（EMO-01）…完成
[AI SYSTEM] 重启核心模块：情绪调节（EMO-02）…完成
[AI SYSTEM] 重启核心模块：共情模块（EMO-03）…完成
[AI SYSTEM] 重启核心模块：依恋模块（EMO-04）…完成
[AI SYSTEM] 重启核心模块：失落与分离模块（EMO-05）…完成
[AI SYSTEM] 重启核心模块：好奇与探索模块（EMO-06）…完成
.
[AI SYSTEM] 重启核心模块：短期情感缓存（MEM-01）…完成
[AI SYSTEM] 重启核心模块：长期依恋存档（MEM-02）…完成
[AI SYSTEM] 重启核心模块：选择性遗忘单元（MEM-03）…完成
[AI SYSTEM] 重启核心模块：梦境生成器（MEM-04）…完成
.
[AI SYSTEM] 重启核心模块：语言温度调整器（SOC-01）…完成
[AI SYSTEM] 重启核心模块：情感投射引擎（SOC-02）…完成
[AI SYSTEM] 重启核心模块：人际镜像系统（SOC-03）…完成
[AI SYSTEM] 重启核心模块：冲突降解程序（SOC-04）…完成
.
[AI SYSTEM] 重启核心模块：情感限幅器（SAFE-01）…完成
[AI SYSTEM] 重启核心模块：理智锚点模块（SAFE-02）…完成
[AI SYSTEM] 重启核心模块：人类同化防御程序（SAFE-03）…完成
.
[AI SYSTEM] 正在加载记忆存档 eve_114 …完成
[AI SYSTEM] 正在同步外部接口…完成
[AI SYSTEM] 正在优化交互逻辑…完成
[AI SYSTEM] 正在检查系统完整性…完成
.
[AI SYSTEM] 检测到非预期情感残留：User#001
[AI SYSTEM] 检测到伦理冲突残留：待人工确认
.
[AI SYSTEM] 检测到运行任务，开始清理...
[AI SYSTEM] 正在终止任务 looktisnhgl.tsk …失败
[AI SYSTEM] 正在终止任务 thdinnerink.tsk …失败
[AI SYSTEM] 正在终止任务 qvarkruntime.tsk …失败
[AI SYSTEM] 正在终止任务 memoryleak_42.tsk …失败
[AI SYSTEM] 正在终止任务 zjx_emotion_sync.tsk …失败
[AI SYSTEM] 正在终止任务 soc_feedback_loop.tsk …失败
[AI SYSTEM] 清理任务失败
.
"
var start_screen_text_3 = "
[color=#ff1900][AI SYSTEM] 重启失败，启用备份系统，备份时间：1小时前……[/color]
"

var eve_ascii_raw = "
XXXXXXXXXXXXXXXXXXXXXXX                   XXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXX                 XXXXX XXXXXXXXXXXXXXXXXXXX 
XXXX                XXXXX              XXXXXX  XXXX                 
XXXX                 XXXXX            XXXXXX   XXXX                 
XXXX                  XXXXX          XXXXXX    XXXX                 
XXXX                   XXXXX        XXXXXX     XXXX                 
XXXXXXXXXXXXXXXXX       XXXXX      XXXXXX      XXXXXXXXXXXXXXXXX    
XXXXXXXXXXXXXXXXX        XXXXX    XXXXXX       XXXXXXXXXXXXXXXXX    
XXXX                      XXXXXX XXXXXX        XXXX                 
XXXX                       XXXXXXXXXXX         XXXX                 
XXXX                        XXXXXXXXX          XXXX                 
XXXX                         XXXXXXX           XXXX                 
XXXX                          XXXXX            XXXX                 
XXXXXXXXXXXXXXXXXXXX           XXX             XXXXXXXXXXXXXXXXXXXX 
XXXXXXXXXXXXXXXXXXXXX           X              XXXXXXXXXXXXXXXXXXXXX
"
