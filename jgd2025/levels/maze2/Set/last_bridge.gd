extends Node3D

var triggered_parkour = false
var triggered_ocean = false
var ocean_ended = false
var parkour_ended = false
var player: Node3D
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print_rich("[color=yellow]警告：[/color]OceanManager 找不到 Player 节点！请确保 Player 在 'player' 分组中。")

signal parkour_started
func _on_parkour_start_body_entered(body: Node3D) -> void:
	if body.name == "Player" and not triggered_parkour:
		triggered_parkour = true
		$Runway._start_pattern()
		parkour_started.emit()

signal ocean_started
func _on_ocean_start_body_entered(body: Node3D) -> void:
	if body.name == "Player" and not triggered_ocean:
		triggered_ocean = true
		ocean_started.emit()
		$OceanScene._start_pattern()


func _on_ocean_end_body_exited(body: Node3D) -> void:
	if body.name == "Player" and not ocean_ended:
		ocean_ended = true
		player.look_at_target($Marker3D)
		await get_tree().create_timer(3.0).timeout
		Transition.set_and_start("坍塌", "")
		LevelManager.to_room()


func _on_parkour_hell_body_entered(body: Node3D) -> void:
	if not ocean_ended and not parkour_ended and body.name == "Player":
		parkour_ended = true
		print("Parkour ended")# todo: reload
