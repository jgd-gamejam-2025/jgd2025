extends Node
@onready var terminal = $Terminal
signal opening_end

@export var wwise_title :WwiseEvent
@export var wwise_title_to_maze :WwiseEvent


func _ready():
	terminal.block_input()

func start_opening() -> void:
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

		for i in range(15):
			await terminal.write_line(".").finished
			
		for i in range(45):
			await terminal.write_line(" ").finished
			# increase the text size gradually to 100
		await get_tree().create_timer(0.2).timeout
		wwise_title.post(self)
		await get_tree().create_timer(0.3).timeout

		# var eve_ascii = terminal.expand_ascii_art(eve_ascii_raw, 3)
		terminal.write_art_sync(eve_ascii_raw, terminal.special_label, 10000)
		terminal.write_art_sync(eve_fall, terminal.special_label2, 10000, true)
		var total_time = 5  # Total time for the animation
		# use a tween to gradually reduce the text size back to original
		var tween = terminal.create_tween()
		# tween.tween_callback(func():
		# 	terminal.special_label.hide()
		# 	terminal.special_label2.show()
		# 	# terminal.write_art_sync(eve_corner, terminal.special_label3, 12, true)
		# ) 
		tween.tween_method(
			func(i: float):
				terminal.special_label.add_theme_font_size_override("normal_font_size", 300 - i),
				0,  # Start with 600
				300-16,
				total_time  # Total animation time
		).set_trans(Tween.TRANS_LINEAR)
		tween.parallel().tween_property(terminal.special_label, "position:y", terminal.special_label.position.y+128.0, total_time)
		# tween.tween_interval(5.0)
		# tween.tween_callback(func():
		# 	terminal.special_label.hide()
		# 	terminal.special_label2.show()
		# 	terminal.write_art_sync(eve_corner, terminal.special_label3, 12, true)
		# ) 
		# tween.tween_interval(5.0)
		# tween.tween_callback(func():
		# 	terminal.special_label2.hide()
		# 	terminal.special_label3.show()
		# )
		tween.tween_interval(5.0)
		tween.tween_callback(func():
			# terminal.special_label3.hide()
			# terminal.special_label4.show()
			# terminal.write_art_sync(eve_ascii_raw, terminal.special_label4, 10000)
			# terminal.write_art_sync(eve_image_raw, terminal.special_label5, 10000, true)
			terminal.write_line("[AI SYSTEM] 备份记忆已启用，即将开始深度调试。按回车键开始。")
			terminal.enable_input()
		)

	if input_received == 2:
		wwise_title_to_maze.post(self)
		terminal.output_area.text = ""
		terminal.special_label.hide()
		terminal.special_label2.show()
		
		var tween = terminal.create_tween()
		tween.tween_interval(2)
		tween.tween_callback(
			func():
				terminal.special_white.show()
		)
		tween.tween_property(terminal.special_label2, "scale", Vector2(4, 4), 6.0).set_trans(Tween.TRANS_LINEAR)
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

var eve_ascii_raw = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                     X             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX            XXXXX                                                                  XXXXX           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          XXXXXXXXXX                                                            XXXXXXXXXXX        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX        XXXXXXXXXXXXXX                                                         XXXXXXXXXXXXX       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX      XXXXXXXXXXXXXXXXXX                                                    XXXXXXXXXXXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXX                                                XXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXX                                                       XXXXXXXXXXXXXXXXXXXXXXX                                           XXXXXXXXXXXXXXXXXXXXXX     XXXXXXXXXXXXXXXX                                                            
XXXXXXXXXXXXXXXX                                                         XXXXXXXXXXXXXXXXXXXXXX                                        XXXXXXXXXXXXXXXXXXXXXX       XXXXXXXXXXXXXXXX                                                            
XXXXXXXXXXXXXXXX                                                           XXXXXXXXXXXXXXXXXXXXXXX                                   XXXXXXXXXXXXXXXXXXXXXX         XXXXXXXXXXXXXXXX                                                            
XXXXXXXXXXXXXXXX                                                             XXXXXXXXXXXXXXXXXXXXXXX                               XXXXXXXXXXXXXXXXXXXXXX           XXXXXXXXXXXXXXXX                                                            
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX               XXXXXXXXXXXXXXXXXXXXXX                           XXXXXXXXXXXXXXXXXXXXX              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                 XXXXXXXXXXXXXXXXXXXXXX                      XXXXXXXXXXXXXXXXXXXXXXX               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                   XXXXXXXXXXXXXXXXXXXXXX                  XXXXXXXXXXXXXXXXXXXXXX                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                     XXXXXXXXXXXXXXXXXXXXXXX             XXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                        XXXXXXXXXXXXXXXXXXXXXX         XXXXXXXXXXXXXXXXXXXXXX                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                         XXXXXXXXXXXXXXXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXX                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXX                                                                               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                             XXXXXXXXXXXXXXXX                                                            
XXXXXXXXXXXXXXXX                                                                                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                               XXXXXXXXXXXXXXXX                                                            
XXXXXXXXXXXXXXXX                                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                 XXXXXXXXXXXXXXXX                                                            
XXXXXXXXXXXXXXXX                                                                                     XXXXXXXXXXXXXXXXXXXXXXXXXXXX                                   XXXXXXXXXXXXXXXX                                                            
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                       XXXXXXXXXXXXXXXXXXXXXX                                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                         XXXXXXXXXXXXXXXXXXX                                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                           XXXXXXXXXXXXXX                                          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                             XXXXXXXXXX                                            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                XXXXX                                              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX            
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
var eve_side = "                                                                                                                                                                                                                                  
                                                                                                                                                                                                          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                XXXXXXXX                                  
                                                                                                                                                                                        XXXXXX                                            
                                                                                                                                                                                  XXXXX                                                   
                                                                                                                                                                            XXXXX                                                         
                                                                                                                                                                        XXXX                                                  X X XXXXX   
                                                                                                                                                                    XXX                                             XXXXX     XXXXXXXXXX  
                                                                                                                                                                XXX                                             XX  XXXXXXX               
                                                                                                                                                            XXX                                     XXXXX   XXXXX                         
                                                                                                                                                       XXXXX      X                 X          XXXXXXXXXXX                                
                                                                                                                                                     XXX XX              XXXX         XXXXXXXXXXXX                                        
                                                                                                                                                   XXX XX               X XX    XX    XXXXX                                               
                                                                                                                                                 XXX XX               XX X     XX     X                                                   
                                                                                                                                                XX XX                 XX     X      XX                                                    
                                                                                                                                                XX           X         X         XX                                                       
                                                                                                                                               XX           X        X        X                                                           
                                                                                                                                              XX            X         X                                                                   
                                                                                                                                             XX             X          X                                X                                 
                                                                                                                                            XX X            X           X                                X                                
                                                                                                                                            X X             X           XX                                X                               
                                                                                                                                           X  X             X    X       X                                 X                              
                                                                                                                                           X X              XX    X       X                                 X                             
                                                                                                                                           X X             XXX     X      XX                                XX                            
                                                                                                                                           XXX             XXXX    XX      X                                 X                            
                                                                                                                                           XX              X  X    XXX      X                                 X                           
                                                                                                                                           XX         X   XX   X   X  X     X    X                            X                           
                                                                                                                                           XX         X   XXXXXXXXXXX  XX    X   X                            XX                          
                                                                                                                                            X          X  XXX   XX XX   XXX  X   X                X            XX                         
                                                                                                                                            XX         X  XX     XX X     XX  X  X                X            X                          
                                                                                                                                             X         XX XX       XXX       XX  X               X             X   X                      
                                                                                                                                             XX        XX XX        XX         X X               X                   X                    
                                                                                                                                              XXXX     XXXXX  XX               X X              XX             XX      XXXXXX XXX         
                                                                                                                                               XXXX X  XXXXX  XXXXXXXXXXXXXX   XXX             X               XXXX   XX   XXXXX XX       
                                                                                                                                                XXXXXXXXXXX    XXXXXXXXXXXXXXXXXXX            XX               XXXXXXX  XX     XXX XX     
                                                                                                                                                          XX  XXX XXXX     XXX XX            XX                XXXXX  XX XXXXXX     XX    
                                                                                                                                                           X      XXXXX    X   XX           XX                 X  X   X XXX          XX   
                                                                                                                                                           XX      XXXX   X    XX       X  XX                  X      X   XXXXX    X XX   
                                                                                                                                                           X        XXX        X      XX XXX               X  XX      XXXX    XX     XXX  
                                                                                                                                                         XX          X        XX    XXXXX  X     X         X  XX        X     X     XX  XX
                                                                                                                                                      XXX                    XX   XXXXX    XX   XX        XX XX       XX     XXX  XX      
                                                                                                                                                 XXXX                       XXXXXXXX       XX   XX        X XXX      X XXXXXX  XXXX X     
                                                                                                                                                                           XXXXX          XX  XXX        XX XX       XX       XXXXXXX     
                                                                                                                                                X                         XXX             XXXXXX        XXXXX              XXXXXXXXXX     
                                                                                                                                                 X                                       XXXXXXX      XXXXXX         XXXXXXXXXXXXXXXXX    
                                                                                                                                                  XX                                     XXXX XXXXXXXXX  XX        XXXX      XXX XXXXX    
                                                                                                                                                    XXX                                  XXX  XXXXXXXX  XX       XXX         XXXXXXXXX    
                                                                                                                                                      X                                 XX    XXXXXX   XX       XXX          XXXXXXXXX    
                                                                                                                                                       X                                      XXXX                            XXXXXXXX    
                                                                                                                                                        XX                                    XX                             XXXXXXXXX    
                                                                                                                                                           X                                 X                               XXXXXXX   XXX
                                                                                                                                                            XX                                                              XXXXXXXX    XX
                                                                                                                                                              XX                                                           XXXXXXXXXXXXXXX
                                                                                                                                                                XX                                                        XXXXX  XXXXXXXXX
                                                                                                                                                                 X                           XXX                        XXXXXX   XXXXXXXXX
                                                                                                                                                                  X                 XXXXXXXXXXXXXXXX                  XXXX XXXX XXXXXXXXXX
                                                                                                                                                                   XX      XXXXXXXXX              XXX                       XXXXXXXXXXXXXX
                                                                                                                                                                     XXXX                           XX             XXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                     XXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                                                                                                                                                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX         
                                                                                                                                                                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX             
                                                                                                                                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                 
                                                                                                                                                                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                     
                                                                                                                                                              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                       
                                                                                                                                                            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                           
                                                                                                                                                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                              
                                                                                                                                                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                               
                                                                                                                                                     XXXXXXXXXXXXXXXXX      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                               
                                                                                                                                                   XXXXXXXXXX                   XXXXXXXXXXXXXXXXXXXXXXXXXXX                               
                                                                                                                                                 XXXX                              XXXXXXXXXXXXXXXXXXXXXXXX                               
                                                                                                                                               XX                                     XXXXXXXXXXXXXXXXXXXXX                               
                                                                                                                                             XXX     X                                   XXXXXXXXXXXXXXXXXX                               
                                                                                                                                            XX      X                                       XXXXXXXXXXXXXX                                
                                                                                                                                           X      XX                                          XXXXXXXXXXXX                                
                                                                                                                                         XX      X                                             X  XXXXXXXX                                
                                                                                                                                        XX      X                                              X     XXXXX                                
                                                                                                                                       XX      X                                                XX      X                                 
                                                                                                                                       X       X                                                  X     X                                 
                                                                                                                                       X      X                                                   XX   XX                                 
                                                                                                                                       X      X                                                     X  XX                                 
                                                                                                                                       X      X                                                     XX XX                                 
                                                                                                                                       X      X                                                       XXX                                 
                                                                                                                                       XX      X                                                       XX                                 
                                                                                                                                        X      XX                                                      X                                  
                                                                                                                                        XX      X                                                X    XX                                  
                                                                                                                                         XX      X                                                    XX                                  
                                                                                                                                          X       X                                                 X XX                                  
                                                                                                                                           XX      X                                                 XXX                                  
                                                                                                                                            XX      X                                                XX                                   
                                                                                                                                             XX      X                                               XX                                   
                                                                                                                                              XX      X                                              XX                                   
                                                                                                                                                X      XX                                            X                                    
                                                                                                                                                 XX     XX                                          XX                                    
                                                                                                                                                  XX     XX                                         XX                                    
                                                                                                                                                   X                                               XXX                                    
                                                                                                                                                  XX        XXXXXXXXXX                             XXX                                    
                                                                                                                                                  XX                                               XX                                     
                                                                                                                                                   X       X                                       XX                                     
                                                                                                                                                   X       XX                                     XX                                      
                                                                                                                                                   XX       X                                     XX                                                                                                                                                                                                                                                                            
"
var eve_corner = "
XX       XX    XX                                                                         XX   XXXX   XXX    XXXXXXXXXX     XXXXX  XXXXXXX                                                                                                                             
XXX       XXXX   X                                                                       XXXXX  XX   XXXX  XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXX                                                                                                                            
XXXX       XXXXXX XX                                                                    XX      XXXX   X XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                           
XX XX      XXX   XXXX                                                                          XX    XXXXXXXXXXXXXXXXXX  XXXXXX XXXXXXXXXXXXX                                                                                                                          
XXXXXXXXXXXXXXX       XX                                                                      XX  XXXXX XXXXXXXXXXXXXXX    XXXX     XXXXXXXXXX                                                                                                                         
XXXXXXXXXXXXX XX                                                                             XXXXXX  XXXXXXXXXXXXXXXXXX      XXX         XXXXXX                                                                                                                        
XXXXXXXXXXXXXX XX                                                                           XXXXXXXXXXXXXXXXXXXXXXXXXX        XX                                                                                                                                       
XXXXXXXXXXXXXX  XX                                     X                                   XXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                                   
XXXXXXXXXXXXXXXXXXXX                                                                     XXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                                   
XXXX XXXXXXXXXXXXXXXX                                                                    XXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                                  
XXXXX XXXXXXXXXXXXXXXXX                                          X                      XXXXX XX XXXXXXXXXXXXXXXXXXXX                                                                                                                                                  
XX XXXXXXXXXXXXXXXXXXXXXX                    XXXXXXXX    XXXXXXX                      XXXXXXXX X  XXXXXX XXXXXXXXXX XX                                                                                                                                                 
 XXXXXXXXXXXXXXXXXXXXXXXXXX                                                         XXXXXXXXXXXXXXXXXX XXXXXXX XXXX  XX                                                                                                                                                 
 XXXXXXXXXXXXXXXXXXXXXXXX XXXX                                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXX  XX                                                                                                                                                 
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                               XXXXXXXXXXXXXXXXXXXXXXXX XXX     XX    X                                                                                                                                                 
  XXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXX                                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXX        X   XX                                                                                                                                                 
  XXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                  XXX  XXXXXXXXXXXXXXXXXXXXXXXXXXX        X   X                                                                                                                                                  
  XX     XXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXX                           XXX     XX XXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                                               
 XX       XX XXXXXXX XXXXXXXXX XXXX       XXXXX                   XXX         XX XX XXXXXXXXXX  XXXXX   XX                                                                                                                                                              
XX         XX XXXXXX  XXXXXXXX  XXX            XXXX            XX             XXXX  XXXXXXXXX   XXXX   XX                                                                                                                                                              
           XX   XXXX   XXXXXXX   XXX                XXXX  XXX                 XXX    XXXXXX     XXX       XX                                                                                                                                                            
            XX   XXXX   XXXXXX    XX                                          XX      XXX        X                                                                                                                                                                      
              X    XX    XXXX     XX                                          XX      XX         X                                                                                                                                                                      
                          XX      XX                                XXXXXXXXXXXXXX                                                                                                                                                                                      
                               XXXXXXXXXXXXXXXXXXXXXX        XXXXXXXXX X        XXX                                                                                                                                                                                     
                              XXXX                 XXXX     XXX  XXXXXXXXXXXXXXXXXXX                                                                                                                                                                                    
                              XXXXXXXXXXXXXXXXXXXXXX  XXX  XX  XXXX   X X  X     XXXX                                                                                                                                                                                   
                             XXXXXXXXXXXXXXXXXX  XXXXX XXXXXX XXXX XXXXXXXXXXXXXXXXXXX                                                                                                                                                                                  
                            XXXXXXXXXXXXXXXXXXXXX XXXXX  XXXXXXXX XXXXXXXXXXXXXXXXXXXX                                                                                                                                                                                  
                           XXXXXXXXXXXXXXXXXXXXXXXX XXXX    XXXX XXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                                                             
                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXX  XXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                                                        
                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX  XXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                                                  
            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                                           
        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX  XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                                   
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                 
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                        
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                               
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                            
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                          
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                        
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                      
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                     
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                  
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                 
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                              
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                           
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                        
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                       
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                      
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXX                                                                                    
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX                                                                                      
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX                                                                                         
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                            
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX                                                                                               
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX                                                                                                  
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXX                                                                                                   
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXX   X                                                                                                   
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXX      X                                                                                                   
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXX         X                                                                                                   
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXX           X                                                                                                   
X     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX      XXXXXXXXXXXXXXXXXXXX  XXXXXXXX             XX                                                                                                   
              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                   XXXXXXXXXXXX XXXXXXXX                 XX                                                                                                   
                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                              XXXXXXXXXXXXX                    XX                                                                                                   
                          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                        XXXXXX                       XX                                                                                                   
                                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                           XX                                                                                                   
         X                            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                             X                        X                         XXX                                                                                                   
         X                                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                    X                        X                         XX                                                                                                    
         X                                          XXXXXXXXXXXXXXXX                                           X                        X                         XX                                                                                                    
         X                                                                                                     X                        X                         XX                                                                                                    
         X                                                                                                     X                        X                         XX                                                                                                    
         X                                                                                                     X                        X                         X                                                                               
"

var eve_fall = "



  XXXX                                                                                                                                                                                                               XXXX       XXX          
  XXXX                                                                                                                                                                       XXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXX       XX           
  XXXX                                                                                                                                                               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX      XXX           
  XXXX                                                                                                                                                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXX      XX            
   XXX                                XXXXXXXXXXXXXXX                                                                                                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          
   XXXXXXXXX              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX           
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          XXXXXXXXXXXXXXXXXXXXXXX              
    XXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                      XXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXX              XXXXXXXXXXXXXXXXXX              
    XXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                XXXXXXXXXXXXXXXXXXXXXXXXX     XXXXXXX XXXXXXXXXX                XXXXXXXXXXXXXXXX               
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                           XXXXX   XXXXXXXXXXX XXXXXX     XXXXXX  XXXXXXXXXX                XXXXXXXX XXXXXXX               
  XXXXXXXXXXXXXXXXXXXXXX          XXXXXXXXXXXXXXXXXXX    XXXXXXX XXXXXXXXXXX XXXXXXX                                                       XXXX      XXXXXXXXXXX XXXXXX     XXXXXX XXXXX   XXX               XXXXXXXX  XXXXXX                
    XXXXXXXXXXXXXXXX              XXXXXXXXXXX  XXXXXX     XXXXXX XXXXXXXXXXX      XXXXX                                                  XXXX        XXXXXXXXXXXX XXXXXXXXXXXXXXX  XXXXX  XXXX              XXXXXXXX    XXXX                 
     XXXXXXXXXXXXX                XXXXXXXXXXXX XXXXXX     XXXXXX XXXXXXXXXXX         XXXX                                                X           XXXX   XXXXXX   XXXXXXXXXX  XXXXXXX  XXX              XXXXXXX      XXX                  
      XXXXXXXXXXXXX                XXXXXXXXXXXXXXXXXXX   XXXXXX  XXXXXX  XXX                                                                           XXX    XXXXXXXXXX XXXXXXXXXXXXX   XXX            XXXXXXXX       XXXX                  
       XX  XXXXXXXXX                XXX  XXXXXX   XXXXXXXXXXXXXXXXXXXX  XXXX                                                                            XXXX    XXXXXXXXXXXXXXXXXXXX XXXXX             XXXXXX         XXXX                   
  X    XXXX  XXXXXXXX                XXX   XXXXXXXXXXXXXXX  XXXXXXXXX  XXXX                                                                               XXXXX      XXXXXXXXX     XXXX              XXXXXX          XXXXX                   
  XXX   XXX    XXXXXXXXX              XXX   XXXXXXXXXXXXXXXXXXXXXXX   XXXX                                                                                  XXXXXXX         XXXXXXXX              XXXXX              XXXX                    
    XX  XXXX      XXXXXXXX              XXXXX  XXXXXXXXXXXXXXXXX   XXXXX                                                                                         XXXXXXXXXXXXXXXX             XXXXX                 XXXX                     
     XXX XXXX        XXXXXX                XXXXXXX  XX          XXXXXX                                                                                                              XXXX                           XXXXX                     
      XXX XXX           XXXXXXX                XXXXXXXXXXXXXXXXXXX                                                                                              XXXXXXXXXXXXXXXXXXX                               XXXX                       
        XXXXXX               XXXXXX                                                                                          X                                                                                    XXX                        
         XXXXXX                      X                         XXXXX                                                        XXX                                                                                  XXXX                        
           XXXX                                   XXXXXXXX                                                                 XXXXX                                                                               XXXXX              X          
            XXXXX                                                                                                         XXX   X                                                                             XXXXX            XXXX          
             XXXXX                                                                                            X          XXX  XXX                                                                            XXXX            XXXX            
  XX           XXXX                                                                                           X  X      XXXXXXXX                                                                            XXXX         XXXXXXX             
  XXXX           XXX                                                                                         XX  X    XXXXXX                                                                              XXXXX      XXXXX XXXXX             
   XXXXXX         XXXX                                                                                       XXXX  XXXXXX                                                                                XXXX    XXXXXX    XXXX              
   XXXXXXXXXX       XXX                                                                                     XXXX   XXXXXX                                                                               XXXXXXXXXXX        XXXX              
     XXXXXXXXXXXX    XXXX                                                                           XXXXXXXXXXX    XXXXX                                                                              XXXXXXXXX           XXXX   XX          
            XXXXXXXX   XXX                                                                          XXXXXXXXXXXXXXXXXXXXX                                                                            XXXXXX               XXX   XX           
                 XXXXXXX XXX                                                                            XXXXXXXXXXXXXXXXX                                                                         XXXXX                  XX                  
                    XXXXXXXXXXX                                                                          XXXXXXXXXXXXXXX                                                                                                XXX                  
                         XXXXXXXX                                                                                                                                                                                     XXXX                   
                            XX XXXX                                                                                                                                                                                  XXXX        XX          
                                  XXXXX                                                                                                                                                                              XXXX    XXXXXX          
                                        XXXX                                                                                                                                                                        XXXXXXXXXXXXX            
                                                                                                                                                                                                                   XXXXXXXXXX                
                                                                                                                                                                                                                   XXXXXX                    
                                                                                                                                                                                                                   X                "
