extends CharacterState

func enter(_msg = {}):
	super()

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	super(_delta)
	if input_converter.stick_position.x < 0:
		state_machine.transition_to("Dash", {"direction": "left"})
		return
	if input_converter.stick_position.x > 0:
		state_machine.transition_to("Dash", {"direction": "right"})
		return
	if input_converter.stick_position.y < 0:
		state_machine.transition_to("CrouchStart")
	if input_converter.can_trigger_action("shield"):
		state_machine.transition_to("Shield")

func exit():
	pass

func on_frame_count_reached() -> void:
	state_machine.transition_to("Idle")

func _notification(_what):
	pass
