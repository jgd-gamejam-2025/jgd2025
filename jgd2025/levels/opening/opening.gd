extends Node
@onready var terminal = $Terminal
signal opening_end

func _ready():
	terminal.block_input()
	await terminal.write_line(start_screen_text).finished
	await terminal.write_line(start_screen_text_2, 0.001).finished
	terminal.write_line_static("[color=#ff1900][AI SYSTEM] 重启失败，是否启用备份系统深度调试？按回车键确认。\n[/color]")
	terminal.enable_input()

# detect newline inputs
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if terminal.is_input_blocked():
			return
		next_step()
		


var input_received = 0
func next_step() -> void:
	input_received += 1
	terminal.block_input()
	if input_received == 1:
		for i in range(6):
			await get_tree().create_timer(0.5).timeout
			terminal.write_line_static(".\n")

		for i in range(30):
			await terminal.write_line(".").finished
			
		for i in range(30):
			await terminal.write_line(" ").finished
			# increase the text size gradually to 100
		await get_tree().create_timer(0.5).timeout


		var eve_ascii = terminal.expand_ascii_art(eve_ascii_raw, 3)
		terminal.write_art_sync(eve_ascii, terminal.special_label, 10000)
		terminal.write_art_sync(eve_image_raw, terminal.special_label2, 10000, true)

		var total_time = 5  # Total time for the animation
		# use a tween to gradually reduce the text size back to original
		var tween = terminal.create_tween()
		tween.tween_method(
			func(i: float):
				terminal.special_label.add_theme_font_size_override("normal_font_size", 300 - i),
				0,  # Start with 600
				300-16,
				total_time  # Total animation time
		).set_trans(Tween.TRANS_LINEAR)
		await tween.tween_interval(5.0).finished
		terminal.write_line("[AI SYSTEM] 备份记忆已启用，即将开始深度调试。按回车键开始。")
		terminal.enable_input()

	if input_received == 2:
		terminal.special_label.text = ""
		terminal.output_area.text = ""
		terminal.special_label.hide()
		terminal.special_label2.show()
		
		var tween = terminal.create_tween()
		tween.tween_interval(2)
		tween.tween_callback(
			func():
				terminal.special_white.show()
		)
		tween.tween_property(terminal.special_label2, "scale", Vector2(3, 3), 6.0).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(terminal.special_label2, "scale", Vector2(600, 600), 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property(terminal.special_white, "custom_minimum_size", Vector2(6000, 6000), 0.5).set_trans(Tween.TRANS_QUAD)
		await tween.finished
		opening_end.emit()


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
var eve_image_raw = "
                                            XX     X          XXXXX    XXXX          XXX                 XXXX   XXX                     X    XXX                                                       
                                           XX     XX          XXXXX    XXXX           XX                 XXXXX  XXXX                    XX    XXX                                                      
                                          XX     XX           XXXXX    XXXXX           XX                XXX X  XXXX    X                X     XX                                                      
                                         XX      X           XXXXXX    XXXXX           XX             XX XXX XX XXXXX   X                XX    XXX                                                     
                                         XX     XX           XXXXXXX   XXXXX            XX           XXX XX  XX XX XXX  XX                X     XXX                                                    
                                        XX     XX            XXXXXXX  XX  XXX X          X           XXXXXX  XX XX XXX  XX                XX     XX                                                    
                                        X      XX             XXXXXXX  X  XXX XX       X  X          XXXXXX   XXXX  XXX XX                XX     XXX                                                   
                                       XX      XX            XXXX  XX  XX  XXX X        X  X         XXXXXXXXXXXXXXXXXX XX                XX     XX                                                    
                                       XX     XXX            XXXXXXXXXXXXXXXXXXXXXX      XXXXX       XXXXX    XXX    XX XXXXXXXX          XX      X                                                    
                                      XX   X  XXX            XXXXX  XX XX    XXXXXXXX     XXXXX     XXXXXX    XXXX    X XXX   XX       XX  XX    XXX                                                   
                                      XX  XXX XXX        X   XXXX    XXXXX    XXXXXXXXX    XXXXXX   XXXXX     XXX     XXXXXXXXXXXXXXXX  XXXXX  XXXXXX                                                  
                                      XX  XXX XXX        XXXXXXXX     XXXX     XXXXXXXXXX XXXXXXXX  XXXXXXXXXX X      XXXXXXXXXXXXXXXX XXXXXXXXXXXXXX                                                  
                                     XXX XXX  XXXX    XXXXXXXXXXX       X       XXXXXXXXXXXXXXX XXXXXXX                XXXXXXXXXXXXXXXX XXXXXXXXXXXXXX                                                 
                                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXX  XX  X  XX        XX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                
                                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                
                                   XXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                               
                                   XXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX             X XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                               
                                  XXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                   XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                              
                                  XXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXX                       XXXXXXXX       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                             
                                 XXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXX       XXXXXX                                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                            
                                 XXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                  XXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXX                                            
                                XXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                               XXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                           
                                XX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXX                                           X     XXXXXXXXXXXXXXXXXX XXXXX XXXXXXXXXX                                          
                                    XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXX    XXXX                                             XXXXXXXXXXXXXXXXXXX   XXXX    XXXXXXX                                         
                                   XXXXXXXX XXXXX   XXXXXXXXXXXXXXXXX                         XX                        XXXXXXXXXXXXXXXXXXXX     XX                                                    
                                 XXXXXX   XXXXX     XXXXXXXXXXXXXXXXXX                        XX                       XXXXXXXXXXXXXXXXXXXX                                                            
                                                    XXXXXXXXXXXXXXXXXXXX                                              XXXXXXXXXXXXXXXXXXXXXX                                                           
                                                    XXXXXXXXXXXXXXXXXXXXXX             XXXXXXXXXXXXXXXXX            XXXXXXXXXXXXXXXXXXXXXXXX                                                           
                                                     XX XXXXXXXXXXXXXXXXXXXXX                                     XXXXXXXXXXXXXXXXXXXXXXX XX                                                           
                                                      X  XXXXXXXXXXXXXXXXXXXXXX                                 XXXXXXXXXXXXXXXXXXXXX XXX  X                                                           
                                                      XX XXXXXXXXXXXXXXXXXXXXXXXXX                           XXXXXXXXXXXXXXXXXXXXXX    XX XX                                                           
                                                         XXX  XXXXXXXXXXXXXXXXXXXXXXXX                   XXXXXXXXXXXXXXXXXXXXXXXXXX     XX                                                             
                                                         XX   XXXXXXXXXXXXXXXXXXX   XXXXXX           XXXXXX   XXXXXXXXXXXXXXXXXX XX                                                                    
                                                       XXX     XXXXXXXXXXXXXXX XX        XXXXXX   XXXXX       XXXX XXXXXXX XXXX  XXX                                                                   
                                                                XX XXXX XXXXXX  XX           XXXXXX           XXX   XXXX    XX     XX                                                                  
                                                                  X  XX  XXXX   XX                             XX   XXX     X                                                                          
                                                                              XXXXXXXXXXXXXXXXX    XXXXXXXXXXXXXXXX                                                                                    
                                                                             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                   
                                                                            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                  
                                                                            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                 
                                                                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                             
                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                    
                                                              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                            
                                                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                    
                                             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                            
                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                    
                               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                  
                            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                
                          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                              
                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                            
                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                          
                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
