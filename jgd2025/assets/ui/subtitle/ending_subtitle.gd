extends Node2D


@onready var animaation_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#play_ending_audio()
	pass
	

func play_ending_audio():
	animaation_player.play("ending_subtitle")
