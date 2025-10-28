class_name Walk extends PlayerState

var input_dir: Vector2
var move_speed: float
var footstep_timer: float = 0.0  # 脚步声计时器
var footstep_interval: float = 0.5  # 当前脚步声间隔
var footstep_interval_forward: float = 0.5  # 前进行走时的脚步声间隔
var footstep_interval_backward: float = 0.6  # 后退时的脚步声间隔


func enter(_msg := {}) -> void:
	player.view_bobbing_amount = player.default_view_bobbing_amount
	footstep_timer = 0.0  # 重置计时器


func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(player.SPRINT) && player.allow_sprint:
		state_machine.transition_to(state_machine.movement_state[state_machine.SPRINT])
	
	# 禁用在使用 pad 时的跳跃
	if event.is_action_pressed(player.JUMP) && player.is_on_floor() && player.allow_jump && not player.pad.is_playing:
		state_machine.transition_to(
			state_machine.movement_state[state_machine.JUMP], 
			{ 
				"player_velocity" : player.velocity, 
				state_machine.TO : state_machine.WALK,
			}
		)
	
	if player.can_crouch && player.allow_crouch:
		if event.is_action_pressed(player.CROUCH) && player.is_on_floor():
			state_machine.transition_to(
				state_machine.movement_state[state_machine.CROUCH],
				{
					state_machine.TO : state_machine.WALK
				}
			)


func physics_update(_delta: float) -> void:
	input_dir = player.input_direction
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir.y > 0:
		move_speed = player.walk_back_speed
		footstep_interval = footstep_interval_backward  # 后退稍慢
	else:
		if player.movement_strength == 0:
			move_speed = player.walk_speed
		else:
			move_speed = player.walk_speed * player.movement_strength
		footstep_interval = footstep_interval_forward  # 正常行走
	
	if direction:
		player.velocity.x = direction.x * move_speed
		player.velocity.z = direction.z * move_speed
		
		# 播放脚步声
		footstep_timer += _delta
		if footstep_timer >= footstep_interval:
			footstep_timer = 0.0
			_play_footstep()
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, move_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, move_speed)
		
		state_machine.transition_to(state_machine.movement_state[state_machine.IDLE])
	
	if player.velocity.y < 0:
		state_machine.transition_to(
			state_machine.movement_state[state_machine.FALL],
			{ state_machine.TO : state_machine.WALK }
		)


func _play_footstep() -> void:
	"""播放脚步声"""
	# 根据当前场景选择对应的 Wwise 事件
	if LevelManager.curr_scene == "room":
		if player.wwise_walk_room:
			player.wwise_walk_room.post(player)
	else:
		if player.wwise_walk_maze:
			player.wwise_walk_maze.post(player)
