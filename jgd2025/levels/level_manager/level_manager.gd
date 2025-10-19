extends Node

@export var eve_debug_scene: PackedScene
var show_opening = true

func to_eve_debug():
	print("Cheat code activated: Transitioning to Eve Debug Scene")
	show_opening = true
	get_tree().change_scene_to_packed(eve_debug_scene)

func restart_eve_debug():
	print("Cheat code activated: Restarting Eve Debug Scene without opening")
	show_opening = false
	get_tree().change_scene_to_packed(eve_debug_scene)
