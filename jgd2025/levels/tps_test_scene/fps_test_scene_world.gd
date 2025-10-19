extends Node3D

@onready var pad = $Player.pad
@onready var chat_ui = pad.chat_ui

@onready var set = $Set

var set_index = 0
var correct_choices = [1, 2, 3]

var curr_set

func _ready():
	Transition.end()
	chat_ui.set_bg_transparent()
	set.hide()
	generate_set(Vector3(0,0,0))
	curr_set.set_question("Q1\n Answer is A", "A", "B", "C")
	await get_tree().create_timer(1).timeout
	curr_set.open_start_doors()

func generate_set(target_position: Vector3) -> void:
	curr_set = set.duplicate()
	add_child(curr_set)
	curr_set.show()
	curr_set.position = target_position
	curr_set.connect("choice_made", choice_made_handler)

func choice_made_handler(idx: int) -> void:
	await get_tree().create_timer(1.5).timeout
	curr_set.open_end_doors()
	var next_position = curr_set.get_next_set_global_position()
	curr_set.disconnect("choice_made", choice_made_handler)
	generate_set(next_position)
	if idx == correct_choices[set_index]:
		set_index += 1

	match set_index:
		0:
			curr_set.set_question("Q1\n Answer is A", "A", "B", "C")
		1:
			curr_set.set_question("Q2\n Answer is B", "A", "B", "C")
		2:
			curr_set.set_question("Q3\n Answer is C", "A", "B", "C")
		_:
			#chat_ui.show_message("Congratulations! You've completed the test!")
			# level_complete()
			return	
	
	await get_tree().create_timer(1.5).timeout
	curr_set.open_start_doors()
	
