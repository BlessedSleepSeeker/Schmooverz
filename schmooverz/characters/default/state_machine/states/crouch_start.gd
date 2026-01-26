extends CharacterState

func enter(_msg := {}) -> void:
	super()
	Buffer.disable_action("ui_left")
	Buffer.disable_action("ui_right")

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if input_converter.stick_position.y < 0:
		character.platdrop.emit()
	if input_converter.can_trigger_action("shield"):
		state_machine.transition_to("Shield")
	if character.is_airborne():
		state_machine.transition_to("Fall")

func exit() -> void:
	Buffer.enable_action("ui_left")
	Buffer.enable_action("ui_right")

func on_frame_count_reached() -> void:
	state_machine.transition_to("Crouch")

func _notification(_what: int) -> void:
	pass