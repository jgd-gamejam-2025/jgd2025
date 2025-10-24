extends Node
@export var chat_1: PackedScene

@export var eve_debug_scene: PackedScene
var show_opening = true

@export var maze2_scene: PackedScene

@export var room_scene: PackedScene

# Save system
const SAVE_FILE_PATH = "user://save_data.cfg"
var config = ConfigFile.new()
var curr_scene = null
# === Save/Load Functions ===

func save_game(scene_name: String, scene_data: Dictionary) -> void:
	Loading.display()
	config.set_value("save", "scene_name", scene_name)
	config.set_value("save", "scene_data", scene_data)
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
	
	print("Game loaded: ", scene_name, " with data: ", scene_data)
	
	# Call the corresponding scene transition function
	match scene_name:
		"eve_debug":
			if scene_data.get("show_opening", true):
				to_eve_debug()
			else:
				restart_eve_debug()
		"maze2":
			to_maze2()
		"room":
			to_room()
		_:
			push_error("Unknown scene name: ", scene_name)
	
	return scene_data

func has_save() -> bool:
	return config.load(SAVE_FILE_PATH) == OK

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
	save_game(curr_scene, {})

func to_room():
	curr_scene = "room"
	get_tree().change_scene_to_packed(room_scene)
	await get_tree().create_timer(0.5).timeout
	save_game(curr_scene, {})
