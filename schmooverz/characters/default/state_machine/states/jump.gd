extends CharacterState
class_name JumpState

@export var dj_minimum_delay: int = 1

func enter(_msg := {}) -> void:
	super()
	if Buffer.is_action_pressed("jump"):
		character.velocity.y = -physics_parameters.FULL_HOP_IMPULSE
	else:
		character.velocity.y = -physics_parameters.SHORT_HOP_IMPULSE

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if character.velocity.y >= 0:
		state_machine.transition_to("Fall")
	if character.is_on_floor():
		state_machine.transition_to("Land")
	if Buffer.is_action_press_buffered("jump") && character.can_double_jump && frame_count > dj_minimum_delay:
		state_machine.transition_to("DoubleJump")

func exit() -> void:
	pass