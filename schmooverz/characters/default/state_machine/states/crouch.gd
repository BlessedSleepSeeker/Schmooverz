extends CharacterState

func enter(_msg := {}) -> void:
	super()

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if character.is_airborne():
		state_machine.transition_to("Fall")
	if input_converter.stick_position.x < 0:
		state_machine.transition_to("Dash", {"direction": "left"})
		return
	if input_converter.stick_position.x > 0:
		state_machine.transition_to("Dash", {"direction": "right"})
		return
	if input_converter.stick_position.y >= 0:
		state_machine.transition_to("CrouchRelease")
	if input_converter.stick_position.y < 0:
		character.platdrop.emit()
	if input_converter.can_trigger_action("jump"):
		state_machine.transition_to("JumpSquat")
	if input_converter.can_trigger_action("shield"):
		state_machine.transition_to("Shield")

func exit() -> void:
	pass

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST || what == Node.NOTIFICATION_WM_GO_BACK_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)