extends CharacterState
class_name DoubleJumpState

func enter(_msg := {}) -> void:
	super()
	character.can_double_jump = false
	character.velocity.y = -physics_parameters.DOUBLE_JUMP_IMPULSE


func unhandled_input(_event: InputEvent):
	super(_event)


func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if character.velocity.y <= 0:
		state_machine.transition_to("Fall")
	if character.is_on_floor():
		state_machine.transition_to("Land")

func exit() -> void:
	pass
