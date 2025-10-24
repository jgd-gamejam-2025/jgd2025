extends Node

@export var eve_debug_scene: PackedScene
var show_opening = true

@export var maze2_scene: PackedScene

@export var room_scene: PackedScene

# Save system
const SAVE_FILE_PATH = "user://save_data.cfg"
var config = ConfigFile.new()

# === Save/Load Functions ===

func save_game(scene_data: Dictionary) -> void:
	var current_scene_path = get_tree().current_scene.scene_file_path
	config.set_value("save", "scene_path", current_scene_path)
	config.set_value("save", "scene_data", scene_data)
	
	var error = config.save(SAVE_FILE_PATH)
	if error == OK:
		print("Game saved: ", current_scene_path, " with data: ", scene_data)
	else:
		push_error("Failed to save game. Error code: ", error)

func load_game() -> Dictionary:
	var error = config.load(SAVE_FILE_PATH)
	if error != OK:
		print("No save file found.")
		return {}
	
	var scene_path = config.get_value("save", "scene_path", "")
	var scene_data = config.get_value("save", "scene_data", {})
	
	if scene_path != "":
		get_tree().change_scene_to_file(scene_path)
	
	print("Game loaded: ", scene_path, " with data: ", scene_data)
	return scene_data

func has_save() -> bool:
	return config.load(SAVE_FILE_PATH) == OK

func delete_save() -> void:
	var dir = DirAccess.open("user://")
	if dir.file_exists("save_data.cfg"):
		dir.remove("save_data.cfg")
		print("Save file deleted")

# === Scene Transition Functions ===

func to_eve_debug():
	print("Cheat code activated: Transitioning to Eve Debug Scene")
	show_opening = true
	save_game({"show_opening": show_opening})
	get_tree().change_scene_to_packed(eve_debug_scene)

func restart_eve_debug():
	print("Cheat code activated: Restarting Eve Debug Scene without opening")
	show_opening = false
	save_game({"show_opening": show_opening})
	get_tree().change_scene_to_packed(eve_debug_scene)

func to_maze2():
	save_game({"show_opening": show_opening})
	get_tree().change_scene_to_packed(maze2_scene)

func to_room():
	save_game({"show_opening": show_opening})
	get_tree().change_scene_to_packed(room_scene)