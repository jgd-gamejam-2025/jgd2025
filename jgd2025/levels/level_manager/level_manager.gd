extends Node
@export var chat_1: PackedScene

@export var eve_debug_scene: PackedScene
var show_opening = true

@export var maze2_scene: PackedScene
var set_index = -1

@export var chat_cut_scene: PackedScene

@export var room_scene: PackedScene

@export var credit_scene: PackedScene

var play_recording = true
@export var end_chat_scene: PackedScene

@export var menu_scene: PackedScene

# Save system
const SAVE_FILE_PATH = "user://save_data.cfg"
var config = ConfigFile.new()
var curr_scene = null
var ai_level: int = 1 # 0-low, 1-standard, 2-high
var end_of_game: bool = false
var in_menu = true
# === Save/Load Functions ===

func _ready() -> void:
	LevelManager.get_save_data()

func save_game(scene_name: String, scene_data: Dictionary) -> void:
	Loading.display()
	config.set_value("save", "scene_name", scene_name)
	config.set_value("save", "scene_data", scene_data)
	config.set_value("save", "ai_level", ai_level)
	var error = config.save(SAVE_FILE_PATH)
	if error == OK:
		print("Game saved: ", scene_name, " with data: ", scene_data)
		await get_tree().create_timer(3).timeout
		Loading.disappear()
	else:
		push_error("Failed to save game. Error code: ", error)

func load_game() -> Dictionary:
	var error = config.load(SAVE_FILE_PATH)
	if error != OK:
		print("No save file found.")
		return {}
	
	var scene_name = config.get_value("save", "scene_name", "")
	var scene_data = config.get_value("save", "scene_data", {})
	ai_level = config.get_value("save", "ai_level", ai_level)
	
	print("Game loaded: ", scene_name, " with data: ", scene_data, " ai_level: ", ai_level)
	
	# Call the corresponding scene transition function
	match scene_name:
		"chat_1":
			to_chat_1()
		"eve_debug":
			# if scene_data.get("show_opening", true):
			# 	to_eve_debug()
			# else:
			restart_eve_debug()
		"maze2":
			if in_menu:
				Wwise.post_event("MX_Play_Maze", self)
			if scene_data.get("set_index", -1) != -1:
				set_index = scene_data["set_index"]
			to_maze2()
		"chat_cut":
			if in_menu:
				Wwise.post_event("Set_AMB_chat", self)
			to_chat_cut_scene()
		"room":
			Wwise.stop_all()
			to_room()
		_:
			push_error("Unknown scene name: ", scene_name)
	in_menu = false
	return scene_data

func has_save() -> bool:
	return config.load(SAVE_FILE_PATH) == OK

func load_use_low_ai() -> bool:
	"""Load only the ai_level setting from save file"""
	var error = config.load(SAVE_FILE_PATH)
	if error != OK:
		print("No save file found, using default ai_level = %s" % ai_level)
		return false
	
	ai_level = config.get_value("save", "ai_level", ai_level)
	print("Loaded ai_level: ", ai_level)
	return ai_level

func save_use_low_ai(value: bool) -> void:
	"""Save only the ai_level setting to save file"""
	ai_level = value
	
	# Load existing config if it exists to preserve other data
	config.load(SAVE_FILE_PATH)
	
	config.set_value("save", "ai_level", ai_level)
	var error = config.save(SAVE_FILE_PATH)
	if error == OK:
		print("ai_level saved: ", ai_level)
	else:
		push_error("Failed to save ai_level. Error code: ", error)

func get_save_data() -> Dictionary:
	"""Read curr_scene, ai_level and scene_data from save file"""
	var error = config.load(SAVE_FILE_PATH)
	if error != OK:
		print("No save file found, returning empty data")
		return {
			"curr_scene": "",
			"ai_level": true,
			"scene_data": {}
		}
	
	var save_data = {
		"curr_scene": config.get_value("save", "scene_name", ""),
		"ai_level": config.get_value("save", "ai_level", ai_level),
		"end_of_game": config.get_value("save", "end_of_game", false),
		"scene_data": config.get_value("save", "scene_data", {})
	}
	curr_scene = save_data["curr_scene"]
	ai_level = save_data["ai_level"]
	end_of_game = save_data["end_of_game"]
	print("Save data retrieved: ", save_data)
	return save_data["scene_data"]

func delete_save() -> void:
	var dir = DirAccess.open("user://")
	if dir.file_exists("save_data.cfg"):
		dir.remove("save_data.cfg")
		print("Save file deleted")

# === Scene Transition Functions ===

func to_chat_1():
	curr_scene = "chat_1"
	get_tree().change_scene_to_packed(chat_1)
	await get_tree().create_timer(0.5).timeout
	save_game(curr_scene, {})

func to_eve_debug():
	print("Cheat code activated: Transitioning to Eve Debug Scene")
	show_opening = true
	curr_scene = "eve_debug"
	get_tree().change_scene_to_packed(eve_debug_scene)
	await get_tree().create_timer(0.5).timeout
	save_game(curr_scene, {"show_opening": show_opening})

func restart_eve_debug():
	print("Cheat code activated: Restarting Eve Debug Scene without opening")
	show_opening = false
	curr_scene = "eve_debug"
	get_tree().change_scene_to_packed(eve_debug_scene)
	await get_tree().create_timer(0.5).timeout
	save_game(curr_scene, {"show_opening": show_opening})

func to_maze2():
	curr_scene = "maze2"
	get_tree().change_scene_to_packed(maze2_scene)
	await get_tree().create_timer(0.5).timeout
	save_game(curr_scene, {"set_index": set_index})

func to_chat_cut_scene():
	curr_scene = "chat_cut"
	get_tree().change_scene_to_packed(chat_cut_scene)
	await get_tree().create_timer(0.5).timeout
	save_game(curr_scene, {})
	
func to_room():
	curr_scene = "room"
	get_tree().change_scene_to_packed(room_scene)
	await get_tree().create_timer(0.5).timeout
	save_game(curr_scene, {})

func to_credit():
	end_of_game = true
	config.load(SAVE_FILE_PATH)
	config.set_value("save", "end_of_game", end_of_game)
	var error = config.save(SAVE_FILE_PATH)
	if error == OK:
		print("end_of_game saved: ", end_of_game)
	else:
		push_error("Failed to save end_of_game. Error code: ", error)

	get_tree().change_scene_to_packed(credit_scene)

func to_menu():
	get_tree().change_scene_to_packed(menu_scene)

func to_end_chat():
	get_tree().change_scene_to_packed(end_chat_scene)
