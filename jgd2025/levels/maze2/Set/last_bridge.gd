extends Node3D

var triggered_parkour = false
var triggered_ocean = false
var ocean_ended = false
var parkour_ended = false
var player: Node3D
@export var wwise_earthquake: WwiseEvent
@export var wwise_rtpc: WwiseRTPC

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
		wwise_rtpc.set_value(LevelManager, 40)

signal ocean_started
func _on_ocean_start_body_entered(body: Node3D) -> void:
	if body.name == "Player" and not triggered_ocean:
		triggered_ocean = true
		ocean_started.emit()
		wwise_rtpc.set_value(LevelManager, 100)
		$OceanScene._start_pattern()
		Wwise.post_event("SFX_pillar_loop", LevelManager)

signal ocean_exit
@export var wwise_mazetrans_to_chat :WwiseEvent
func _on_ocean_end_body_exited(body: Node3D) -> void:
	if body.name == "Player" and not ocean_ended:
		ocean_ended = true
		ocean_exit.emit()
		# player.look_at_target($Marker3D)
		wwise_mazetrans_to_chat.post(LevelManager)
		# wwise_rtpc.set_value(LevelManager, 100)
		await get_tree().create_timer(6.85).timeout
		Transition.set_and_start("坍塌", "", 0, "N/A")	
		wwise_earthquake.stop(LevelManager)
		await get_tree().create_timer(3).timeout
		LevelManager.to_chat_cut_scene()


func _on_parkour_hell_body_entered(body: Node3D) -> void:
	if not ocean_ended and not parkour_ended and body.name == "Player":
		parkour_ended = true
		Transition.set_and_start("", "", 0, "N/A")	
		await get_tree().create_timer(0.2).timeout
		LevelManager.load_game()
