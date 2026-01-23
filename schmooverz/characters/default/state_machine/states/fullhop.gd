extends CharacterState

func enter(_msg = {}):
	super()
	character.velocity.y = character.physics_parameters.FULL_HOP_IMPULSE

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	super(_delta)
	if not character.is_airborne():
		state_machine.transition_to("Land")
	if Buffer.is_action_press_buffered("jump"):
		state_machine.transition_to("DoubleJump")
	if character.velocity.y < 0:
		state_machine.transition_to("Fall")

func exit():
	pass

func on_frame_count_reached():
	state_machine.transition_to("Fall")

func _notification(_what):
	pass
