extends CharacterState
class_name FallState

@export var dj_minimum_delay: int = 6

var future_land_lag: int = 3
var is_fastfalling: bool = false

func enter(_msg := {}) -> void:
	super()
	future_land_lag = 3
	if _msg["PreviousState"] == "FullHop":
		future_land_lag = 6

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	character.direction.x = input_converter.stick_position.x

	if input_converter.stick_position.x == 0.0:
		character.velocity = character.velocity.move_toward(character.direction * character.physics_parameters.MAX_SPEED, character.physics_parameters.FRICTION * _delta)
	else:
		character.velocity = character.velocity.move_toward(character.direction * character.physics_parameters.MAX_SPEED, character.physics_parameters.ACCELERATION * _delta)
	character.velocity.y += (character.physics_parameters.FAST_FALL_SPEED if is_fastfalling else character.physics_parameters.GRAVITY) * _delta
	if input_converter.stick_position.y < 0:
		is_fastfalling = true
	super(_delta)
	if character.is_on_floor():
		state_machine.transition_to("Land")
	if Buffer.is_action_press_buffered("jump") && character.can_double_jump && frame_count > dj_minimum_delay:
		state_machine.transition_to("DoubleJump")

func exit() -> void:
	is_fastfalling = false
