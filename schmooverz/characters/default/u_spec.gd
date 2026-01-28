extends CharacterStateAttack

func during_startup():
	super()

func during_active_frame(_index):
	super(_index)
	character.velocity = Vector3(0, 20, 0)

func during_inactive_frame(_index):
	super(_index)

func during_endlag():
	super()

func enter(_msg = {}):
	super()
	character.velocity = Vector3.ZERO

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	super(_delta)

func exit():
	super()

func on_frame_count_reached():
	super()
	state_machine.transition_to("Freefall")

func _notification(_what):
	pass
