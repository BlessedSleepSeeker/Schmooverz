extends CharacterState
class_name RunState


func enter(_msg := {}) -> void:
	super()
	#FramePrint.prt("Current X Speed : %s" % character.velocity.x)

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	#FramePrint.prt(character.velocity.x)
	if character.is_airborne():
		state_machine.transition_to("Fall")
	if character.velocity == Vector3.ZERO:
		state_machine.transition_to("Idle")
	if input_converter.can_trigger_action("jump"):
		state_machine.transition_to("JumpSquat")

	if input_converter.can_trigger_action("dash_attack"):
		state_machine.transition_to("DashAttack")
	if input_converter.can_trigger_action("uspec"):
		state_machine.transition_to("USpec")

	if Buffer.is_action_press_buffered("shield"):
		state_machine.transition_to("Shield")
	if input_converter.stick_position.y < 0:
		state_machine.transition_to("CrouchStart")
		character.platdrop.emit()
	if input_converter.stick_position.x < 0 && character.facing_direction == true:
		state_machine.transition_to("RunTurnaround")
	if input_converter.stick_position.x > 0 && character.facing_direction == false:
		state_machine.transition_to("RunTurnaround")
	

func exit() -> void:
	pass#FramePrint.prt(character.velocity.x)

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST || what == Node.NOTIFICATION_WM_GO_BACK_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)