extends Node

@export var eve_debug_scene: PackedScene
var show_opening = true

@export var maze2_scene: PackedScene

@export var room_scene: PackedScene

func to_eve_debug():
	print("Cheat code activated: Transitioning to Eve Debug Scene")
	show_opening = true
	get_tree().change_scene_to_packed(eve_debug_scene)

func restart_eve_debug():
	print("Cheat code activated: Restarting Eve Debug Scene without opening")
	show_opening = false
	get_tree().change_scene_to_packed(eve_debug_scene)

func to_maze2():
	get_tree().change_scene_to_packed(maze2_scene)

func to_room():
	get_tree().change_scene_to_packed(room_scene)