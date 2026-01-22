extends CharacterState
class_name DoubleJumpState

func enter(_msg := {}) -> void:
	super()
	character.can_double_jump = false
	character.velocity.y = character.physics_parameters.DOUBLE_JUMP_IMPULSE
	character.skin.spin(0.3)

func unhandled_input(_event: InputEvent):
	super(_event)


func physics_update(_delta: float, _move_character: bool = true) -> void:
	character.direction.x = input_converter.stick_position.x

	if input_converter.stick_position.x == 0.0:
		character.velocity = character.velocity.move_toward(character.direction * character.physics_parameters.MAX_SPEED, character.physics_parameters.FRICTION * _delta)
	else:
		character.velocity = character.velocity.move_toward(character.direction * character.physics_parameters.MAX_SPEED, character.physics_parameters.ACCELERATION * _delta)
	super(_delta)
	if character.velocity.y <= 0:
		state_machine.transition_to("Fall")
	if character.is_on_floor():
		state_machine.transition_to("Land")

func exit() -> void:
	character.skin.reset_spin()
