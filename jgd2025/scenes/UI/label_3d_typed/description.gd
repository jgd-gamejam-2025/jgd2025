extends Node3D

func show_effect() -> void:
	# find all children and call "show_effect" if they have it
	for child in get_children():
		if child.has_method("show_effect"):
			child.call("show_effect")

func hide_effect() -> void:
	# find all children and call "hide_effect" if they have it
	for child in get_children():
		if child.has_method("hide_effect"):
			child.call("hide_effect")
			
