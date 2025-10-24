extends Node3D

var triggered_parkour = false
var triggered_ocean = false
var ocean_ended = false
func _on_parkour_start_body_entered(body: Node3D) -> void:
	if body.name == "Player" and not triggered_parkour:
		triggered_parkour = true
		$Runway._start_pattern()


func _on_ocean_start_body_entered(body: Node3D) -> void:
	if body.name == "Player" and not triggered_ocean:
		triggered_ocean = true
		$OceanScene._start_pattern()


func _on_ocean_end_body_exited(body: Node3D) -> void:
	if body.name == "Player" and not ocean_ended:
		ocean_ended = true
		Transition.set_and_start("", "")
		LevelManager.to_room()
