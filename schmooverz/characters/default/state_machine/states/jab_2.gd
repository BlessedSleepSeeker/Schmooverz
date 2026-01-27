extends CharacterStateAttack

func during_startup():
	pass

func during_active_frame(_index: int):
	super(_index)

func during_inactive_frame(_index: int):
	super(_index)

func during_endlag():
	super()
	if can_iasa():
		if input_converter.can_trigger_action("jab"):
			state_machine.transition_to("Jab3")

func enter(_msg = {}):
	super()

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	_frame_dispatcher()
	super(_delta)

func exit():
	pass

func on_frame_count_reached():
	state_machine.transition_to("Idle")

func _notification(_what):
	pass
