extends CharacterState
class_name RunState


func enter(_msg := {}) -> void:
	super()
	#FramePrint.prt("Current X Speed : %s" % character.velocity.x)

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	#FramePrint.prt("Current X Speed : %s" % character.velocity.x)
	character.direction.x = input_converter.stick_position.x

	if input_converter.stick_position.x == 0.0:
		character.velocity = character.velocity.move_toward(character.direction * character.physics_parameters.MAX_SPEED, character.physics_parameters.FRICTION * _delta)
	else:
		character.velocity = character.velocity.move_toward(character.direction * character.physics_parameters.MAX_SPEED, character.physics_parameters.ACCELERATION * _delta)

	super(_delta)
	if character.is_airborne():
		state_machine.transition_to("Fall")
	if character.velocity == Vector3.ZERO:
		state_machine.transition_to("Idle")
	if Buffer.is_action_press_buffered("jump"):
		state_machine.transition_to("JumpSquat")
	if Buffer.is_action_press_buffered("attack"):
		state_machine.transition_to("AttackDispatcher")
	if Buffer.is_action_press_buffered("shield"):
		state_machine.transition_to("Shield")
	if input_converter.stick_position.y < 0:
		state_machine.transition_to("CrouchStart")

	character.direction = Vector3.ZERO
	

func exit() -> void:
	pass

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST || what == Node.NOTIFICATION_WM_GO_BACK_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)