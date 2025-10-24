extends Node3D

var has_made_choice = false
var choice_idx = 0

signal choice_made(idx: int)

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
	
func open_load_gate():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(%LoadGate, "position:x", %LoadGate.position.x - 30.0, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)


signal hell
func _on_hell_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		hell.emit()

signal load_next
var send_load_next = false
func _on_load_next_body_entered(body: Node3D) -> void:
	if body.name == "Player" and not send_load_next:
		send_load_next = true
		load_next.emit()
