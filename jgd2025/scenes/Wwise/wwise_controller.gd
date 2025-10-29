extends Node

@onready var listener: AkListener3D = $AkListener3D 

func _ready() -> void:
	Wwise.register_game_obj(LevelManager, "MX_Emitter")
	Wwise.set_listeners(LevelManager, [listener])
