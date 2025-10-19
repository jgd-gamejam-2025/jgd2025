extends Node3D

var has_made_choice = false
var choice_idx = 0

signal choice_made(idx: int)

func open_start_doors():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(%Ldoor, "position:x", %Ldoor.position.x - 24.0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(%Rdoor, "position:x", %Rdoor.position.x + 24.0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func open_end_doors():
	var tween = create_tween()
	tween.tween_property(%EndDoor, "position:y", %EndDoor.position.y + 24.0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func make_choice(idx: int) -> void:
	if has_made_choice:
		return
	has_made_choice = true
	choice_idx = idx
	choice_made.emit(idx)

func _on_option_3_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		make_choice(3)

func _on_option_2_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		make_choice(2)


func _on_option_1_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		make_choice(1)

func get_next_set_global_position() -> Vector3:
	return $NextPosition.global_position

func set_question(question: String, opt1:String, opt2:String, opt3:String):
	var end_label = %Judge.get_node("EndLabel")
	var op1_label = %Judge.get_node("Option1/Label1")
	var op2_label = %Judge.get_node("Option2/Label2")
	var op3_label = %Judge.get_node("Option3/Label3")

	end_label.text = question
	op1_label.text = opt1
	op2_label.text = opt2
	op3_label.text = opt3
	
	
	
