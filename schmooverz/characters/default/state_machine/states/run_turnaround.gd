extends CharacterState

var direction_multiplier: float = 1

func enter(_msg = {}):
	super()
	FramePrint.prt(character.velocity.x)
	self.set_frame_duration = character.physics_parameters.RUN_TURNAROUND_DURATION
	character.facing_direction = !character.facing_direction
	if character.facing_direction == true:
		direction_multiplier = 1
	else:
		direction_multiplier = -1

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	character.velocity.x += (character.physics_parameters.RUN_TURNAROUND_ACCELERATION * direction_multiplier)
	character.velocity.x = clampf(character.velocity.x, -character.physics_parameters.MAX_RUN_SPEED, character.physics_parameters.MAX_RUN_SPEED)
	FramePrint.prt(character.velocity.x)
	super(_delta)
	FramePrint.prt(character.velocity.x)

func exit():
	character.orient_skin()

func on_frame_count_reached():
	state_machine.transition_to("Run")

func _notification(_what):
	pass
