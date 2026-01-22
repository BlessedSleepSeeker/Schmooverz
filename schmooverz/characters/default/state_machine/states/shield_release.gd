extends CharacterState

func enter(_msg = {}):
	super()

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	super(_delta)

func exit():
	pass

func on_frame_count_reached():
	state_machine.transition_to("Idle")

func _notification(_what):
	pass
