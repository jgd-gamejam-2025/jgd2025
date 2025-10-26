class_name Fall extends PlayerState

## Variable for storing the state prior to falling
var init_state: int

@export var wwise_maze_landing :WwiseEvent

func enter(msg := {}) -> void:
	player.view_bobbing_amount = player.default_view_bobbing_amount
	player.is_affected_by_gravity = true
	if msg:
		init_state = msg[state_machine.TO]


func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		if LevelManager.curr_scene != "room":
			wwise_maze_landing.post(self)
		state_machine.transition_to(state_machine.movement_state[init_state])
	
	if not player.input_direction:
		init_state = state_machine.WALK
	
	if Input.is_action_pressed(player.JUMP) && player.can_climb && player.allow_climb:
		if player.check_climbable():
			state_machine.transition_to(
				state_machine.movement_state[state_machine.GRAB],
				{ "ledge_position" = player.ledge_position }
			)
