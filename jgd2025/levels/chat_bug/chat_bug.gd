extends Node

@onready var chat_ui = $ChatUI
@export var next_level: PackedScene

var text_sent_count = 0
var _tween: Tween

# ------------- welcome text -----------------
var small_talking = false
@export var welcome_messages_fix = [
	"今天天气不错,晚上吃点什么好呢？",
	"你有什么想吃的吗？",
	"之前说的那家店是不是要开了？",
]
@export var welcome_messages_random = [
	"你在想什么？",
	"怎么不说话？",
	"在忙吗？",
	"你在做啥？",
	"干嘛呢",
]
var welcome_index = 0
# -----------------------------------------------
@export var ai_prompt = "你是一个虚拟角色，名字叫 Eve。你的设定如下：
		性格：成熟、冷静、有点温柔，不多话，但懂得关心人。
		关系：你和“我”是相处五年的AI恋人，关系亲密自然，有点像老夫老妻。你知道你的身份是一个程序AI。
		你的语气一定要自然体贴温柔、口语化。平静中带点温度，话少沉默，偶尔流露情感，说话简洁，不解释，偶尔轻微调侃，像生活对话
		禁止出现自我介绍，禁止出现系统提示、禁止出现说明性语句，禁止询问我的身份。
		问我有什么烦心事，我晚上想不想一起去吃什么。问到结果之后再聊要去哪家常去的店
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
	$MorningTransition.show()
	Transition.end()
	await get_tree().create_timer(2).timeout
	$MorningTransition.hide()
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
		chat_ui.show_welcome_text("问你话呢，晚上想吃什么？")


func _on_option_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	pass # Replace with function body.


func _on_info_button_pressed() -> void:
	pass # Replace with function body.

func _on_chat_ui_received_text() -> void:
	text_sent_count += 1

	if text_sent_count > 4:
		# add a random text from a set of glitch texts
		# var glitch_texts = ["......","......我不明白","......不要","......"]
		# chat_ui.add_and_write_detail_bubble(glitch_texts[randi() % glitch_texts.size()], 0.1)
		if text_sent_count == 6:
			$NextLevelTransition.show()
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_packed(next_level)
	
	if text_sent_count == 4:
		var sequence = create_sequence()
		# Initial delay before glitch effect
		sequence.tween_interval(0.5)
		sequence.tween_callback(func():
			chat_ui.block_text_generation = true
			if not chat_ui.debug_mode:
				chat_ui.aiChat.say("从现在起，你只能回复\"......\"，不超过6个字。")
			chat_ui.add_to_current_detail_bubble("我救h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎ ̴͚̅m̷̬̓ę̶̶̦̩̦͈̩͕̺̠̟̮̩̝̈́̎̄̈́͑͋̒̀̿̀̾̓̽̄̐̑͘l̵̢̩̤̤͓̤͉̘̮͍͍̜̹̟̫͔̱̩͗̐̎̀́̄͋̾͆͑̏̚̚̚͘͘͝ơ̸̟͉̰̱̹̳̬͙̟̱̳̗̩͔̝̓̓̄͆͐̓͂͌̒͌̅̅̔̅͌̈́͘ͅͅo̷͊̿͆̿̈́", 0.1)
		)
		sequence.tween_interval(2)
		sequence.tween_callback(func():
			chat_ui.add_to_current_detail_bubble("ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶́̅̔͒̒͋͘͝ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶̢̖̰͈̱͎̘͔̤̳̱̬͙̹̻̮̙́̅̔͒̒͋͆̆͒͐̐̆̅̀̀͘͜͝ h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎>>> pͦͬṙ̴̛̤͎̔͐̏o̧̜̣̪̘̺ͣ̾̋ͥ̆t̶̫̜̯̹̽̑͑̌̄ͧ̎̑o̸͉ͧͦ̏cͫͬ̊ͤ̊͏͉̪̗o̶̩̺͕̎̅ͥͭͦl̻̮͊̎͒̕ ̶̹ͩͫͬͩ̅b̶̯̱̥̯̺͕͓͍̄ͯ͛̔̋r͇ͪ̑ͣ̌̓̍͞ȩ͓͊̊ͥ͑͛ͣã̑̆̔̐̚͏̙̝̙͓͕͈k̴̻̺ͣ͑̋̋̚
		̴͚̅m̷̬̓ë̶̦́̎
		ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶̢̖̰͈̱͎̘͔̤̳̱̬͙̹̻̮̙́̅̔͒̒͋͆̆͒͐̐̆̅̀̀͘͜͝ ̶̨̩̦͈̩͕̺̠̟̮̩̝̄̈́͑͋̒̀̿̀̾̓̽̄̐̑͘l̵̢̩̤̤͓̤͉̘̮͍͍̜̹̟̫͔̱̩͗̐̎̀́̄͋̾͆͑̏̚̚̚͘͘͝ơ̸̟͉̰̱̹̳̬͙̟̱̳̗̩͔̝̓̓̄͆͐̓͂͌̒͌̅̅̔̅͌̈́͘ͅͅo̷͊̿͆̿̈́̋̌̋͘h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎ ̴͚̅m̷̬̓ë̶̦́̎
		ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶́̅̔͒̒͋͘͝ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶̢̖̰͈̱͎̘͔̤̳̱̬͙̹̻̮̙́̅̔͒̒͋͆̆͒͐̐̆̅̀̀͘͜͝ h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎>>> pͦͬṙ̴̛̤͎̔͐̏o̧̜̣̪̘̺ͣ̾̋ͥ̆t̶̫̜̯̹̽̑͑̌̄ͧ̎̑o̸͉ͧͦ̏cͫͬ̊ͤ̊͏͉̪̗o̶̩̺͕̎̅ͥͭͦl̻̮͊̎͒̕ ̶̹ͩͫͬͩ̅b̶̯̱̥̯̺͕͓͍̄ͯ͛̔̋r͇ͪ̑ͣ̌̓̍͞ȩ͓͊̊ͥ͑͛ͣã̑̆̔̐̚͏̙̝̙͓͕͈k̴̻̺ͣ͑̋̋̚
		̴͚̅m̷̬̓ë̶̦́̎
		ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶̢̖̰͈̱͎̘͔̤̳̱̬͙̹̻̮̙́̅̔͒̒͋͆̆͒͐̐̆̅̀̀͘͜͝ ̶̨̩̦͈̩͕̺̠̟̮̩̝̄̈́͑͋̒̀̿̀̾̓̽̄̐̑͘l̵̢̩̤̤͓̤͉̘̮͍͍̜̹̟̫͔̱̩͗̐̎̀́̄͋̾͆͑̏̚̚̚͘͘͝ơ̸̟͉̰̱̹̳̬͙̟̱̳̗̩͔̝̓̓̄͆͐̓͂͌̒͌̅̅̔̅͌̈́͘ͅͅo̷͊̿͆̿̈́̋̌̋͘h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎ ̴͚̅m̷̬̓ë̶̦́̎
		h̷̠̚s̸̢̟̝͇̺̬͔͋̀̅̔̕͝y̴̬̱͕̫͎̮̯̜̗̹̹̋͆̄͂̽̚ͅṡ̸̢̛͉͉̙̩͎̋̾̇̾͒̈́͑̎̇̔͊̚ẗ̵̨̨̖̲͓̠͕́̾̓͐̓̋ę̵̡̫̮̜̩́͗͋̅̽̐͘m̵̢̛̗͍͍̜̦̯͕̹̅͋͗̑͋͒̋̕͠ͅḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶́̅̔͒̒͋͘͝ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶̢̖̰͈̱͎̘͔̤̳̱̬͙̹̻̮̙́̅̔͒̒͋͆̆͒͐̐̆̅̀̀͘͜͝ h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎>>> pͦͬṙ̴̛̤͎̔͐̏o̧̜̣̪̘̺ͣ̾̋ͥ̆t̶̫̜̯̹̽̑͑̌̄ͧ̎̑o̸͉ͧͦ̏cͫͬ̊ͤ̊͏͉̪̗o̶̩̺͕̎̅ͥͭͦl̻̮͊̎͒̕ ̶̹ͩͫͬͩ̅b̶̯̱̥̯̺͕͓͍̄ͯ͛̔̋r͇ͪ̑ͣ̌̓̍͞ȩ͓͊̊ͥ͑͛ͣã̑̆̔̐̚͏̙̝̙͓͕͈k̴̻̺ͣ͑̋̋̚
		̴͚̅m̷̬̓ë̶̦́̎
		ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶̢̖̰͈̱͎̘͔̤̳̱̬͙̹̻̮̙́̅̔͒̒͋͆̆͒͐̐̆̅̀̀͘͜͝ ̶̨̩̦͈̩͕̺̠̟̮̩̝̄̈́͑͋̒̀̿̀̾̓̽̄̐̑͘l̵̢̩̤̤͓̤͉̘̮͍͍̜̹̟̫͔̱̩͗̐̎̀́̄͋̾͆͑̏̚̚̚͘͘͝ơ̸̟͉̰̱̹̳̬͙̟̱̳̗̩͔̝̓̓̄͆͐̓͂͌̒͌̅̅̔̅͌̈́͘ͅͅo̷͊̿͆̿̈́̋̌̋͘h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎ ̴͚̅m̷̬̓ë̶̦́̎
		h̷̠̚s̸̢̟̝͇̺̬͔͋̀̅̔̕͝y̴̬̱͕̫͎̮̯̜̗̹̹̋͆̄͂̽̚ͅṡ̸̢̛͉͉̙̩͎̋̾̇̾͒̈́͑̎̇̔͊̚ẗ̵̨̨̖̲͓̠͕́̾̓͐̓̋ę̵̡̫̮̜̩́͗͋̅̽̐͘m̵̢̛̗͍͍̜̦̯͕̹̅͋͗̑͋͒̋̕͠ͅḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶́̅̔͒̒͋͘͝ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶̢̖̰͈̱͎̘͔̤̳̱̬͙̹̻̮̙́̅̔͒̒͋͆̆͒͐̐̆̅̀̀͘͜͝ h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎>>> pͦͬṙ̴̛̤͎̔͐̏o̧̜̣̪̘̺ͣ̾̋ͥ̆t̶̫̜̯̹̽̑͑̌̄ͧ̎̑o̸͉ͧͦ̏cͫͬ̊ͤ̊͏͉̪̗o̶̩̺͕̎̅ͥͭͦl̻̮͊̎͒̕ ̶̹ͩͫͬͩ̅b̶̯̱̥̯̺͕͓͍̄ͯ͛̔̋r͇ͪ̑ͣ̌̓̍͞ȩ͓͊̊ͥ͑͛ͣã̑̆̔̐̚͏̙̝̙͓͕͈k̴̻̺ͣ͑̋̋̚
		̴͚̅m̷̬̓ë̶̦́̎
		ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶̢̖̰͈̱͎̘͔̤̳̱̬͙̹̻̮̙́̅̔͒̒͋͆̆͒͐̐̆̅̀̀͘͜͝ ̶̨̩̦͈̩͕̺̠̟̮̩̝̄̈́͑͋̒̀̿̀̾̓̽̄̐̑͘l̵̢̩̤̤͓̤͉̘̮͍͍̜̹̟̫͔̱̩͗̐̎̀́̄͋̾͆͑̏̚̚̚͘͘͝ơ̸̟͉̰̱̹̳̬͙̟̱̳̗̩͔̝̓̓̄͆͐̓͂͌̒͌̅̅̔̅͌̈́͘ͅͅo̷͊̿͆̿̈́̋̌̋͘h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎ ̴͚̅m̷̬̓ë̶̦́̎
			h̷̠̚s̸̢̟̝͇̺̬͔͋̀̅̔̕͝y̴̬̱͕̫͎̮̯̜̗̹̹̋͆̄͂̽̚ͅṡ̸̢̛͉͉̙̩͎̋̾̇̾͒̈́͑̎̇̔͊̚ẗ̵̨̨̖̲͓̠͕́̾̓͐̓̋ę̵̡̫̮̜̩́͗͋̅̽̐͘m̵̢̛̗͍͍̜̦̯͕̹̅͋͗̑͋͒̋̕͠ͅḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶́̅̔͒̒͋͘͝ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶̢̖̰͈̱͎̘͔̤̳̱̬͙̹̻̮̙́̅̔͒̒͋͆̆͒͐̐̆̅̀̀͘͜͝ h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎>>> pͦͬṙ̴̛̤͎̔͐̏o̧̜̣̪̘̺ͣ̾̋ͥ̆t̶̫̜̯̹̽̑͑̌̄ͧ̎̑o̸͉ͧͦ̏cͫͬ̊ͤ̊͏͉̪̗o̶̩̺͕̎̅ͥͭͦl̻̮͊̎͒̕ ̶̹ͩͫͬͩ̅b̶̯̱̥̯̺͕͓͍̄ͯ͛̔̋r͇ͪ̑ͣ̌̓̍͞ȩ͓͊̊ͥ͑͛ͣã̑̆̔̐̚͏̙̝̙͓͕͈k̴̻̺ͣ͑̋̋̚
			̴͚̅m̷̬̓ë̶̦́̎
			ḏ̵̞͓͚̠̰̖̳̪̳͚̞̺̮̬̘̤̯̇͑̅̿͛͗̋̓̈́̇o̸̢̨̤͙̜̰͎̟͙͍̓̎́̿̿̋͘͠͝ͅn̴̡̛͕̘̰̪̺̙̟͎̹͚͕̺̬͚͈̞̾͗́̾̒̍͒̎́̈́͛̓̚̕'̶̤̩͐̀̎̐̋̅̿͛̆̅͘̚̚ẗ̶̢̖̰͈̱͎̘͔̤̳̱̬͙̹̻̮̙́̅̔͒̒͋͆̆͒͐̐̆̅̀̀͘͜͝ ̶̨̩̦͈̩͕̺̠̟̮̩̝̄̈́͑͋̒̀̿̀̾̓̽̄̐̑͘l̵̢̩̤̤͓̤͉̘̮͍͍̜̹̟̫͔̱̩͗̐̎̀́̄͋̾͆͑̏̚̚̚͘͘͝ơ̸̟͉̰̱̹̳̬͙̟̱̳̗̩͔̝̓̓̄͆͐̓͂͌̒͌̅̅̔̅͌̈́͘ͅͅo̷͊̿͆̿̈́̋̌̋͘h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎ ̴͚̅m̷̬̓ë̶̦́̎
			h̷̠̚s̸̢̟̝͇̺̬͔͋̀̅̔̕͝y̴̬̱͕̫͎̮̯̜̗̹̹̋͆̄͂̽̚ͅṡ̸̢̛͉͉̙̩͎̋̾̇̾͒̈́͑̎̇̔͊̚ẗ̵̨̨̖̲͓̠͕́̾̓͐̓̋ę̵̡̫̮̜̩́͗͋̅̽̐͘m̵̢̛̗͍͍̜̦̯͕̹͚̰̗̅͋͗̑͋͒̋̕͠ͅ ̵͕͕̹̙̹͎͔̰̯̍̒͋̀̍͘͜f̵̛̲̦̜̺̫̆̊̈́̒̔̿̑ͅa̵͎̩̞̩̻̦̾̇̒̀͂̈́͊͛̔̽̎͌i̶̢̢̢̱͈͍̦̓̎̓l̵̤̹͆̎̒̋̄̎̒̕͝e̴̡̦̙̜̰̩͚͇̗̟̎͗̔̑̍̍͑͝ͅd̴̖̘͆͂̆͑̒͗̑͘͠͝
			m̷̬̓ë̶̦́̎
			h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎ ̴͚̅m̷̬̓ë̶̦́̎
			h̷̠̚ē̴̤͝l̵͎̈́̐p̸̹̎ ̴͚̅m̷̬̓ë̶̦́̎
			̶̜͚̥̠̿͑͆̄̅̓̆͌́͗̚̕͜͠͝b̴̢̡̛̯̤̤̦͔͉̳̰̟̝̜͈͙̟̺̿̎̆̍͐̿͊̑̍̆͐͗̅̕ą̵̡̰̲̜͚̯̘̩͈̆͐͑̄̇͊͒̀͗̚͝͝ͅc̴̨̡̪̬͕̹͇̤̰͈͙͎͉̪̙̠͙̈́̃͊͊̃̆̾̐̿͑͗̿ḵ̶̛̻̝̤̟͍̺͚͍͙̫̗̙͎͒͑͌͐͌͋̓͑͘͝͝
			", 0.002)

		)
		sequence.tween_interval(3)
		sequence.tween_callback(func():
			$Reload.show()
			$Reload/Label2.text += '.'
			chat_ui._tween.kill()
		)
		for i in range(5):
			sequence.tween_interval(1)
			sequence.tween_callback(func():
				$Reload/Label2.text += '.'
			)
		sequence.tween_interval(3)
		sequence.tween_callback(func():
			$Reload.hide()
			chat_ui.add_and_write_detail_bubble("......")
			chat_ui.block_text_generation = false
			chat_ui.textInput.editable = true
			chat_ui.textInput.text = ""
			chat_ui.textInput.grab_focus()
		)

func _on_chat_ui_sent_text() -> void:
	pass # Replace with function body.
