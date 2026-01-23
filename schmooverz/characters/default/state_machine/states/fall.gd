extends CharacterState
class_name FallState

@export var dj_minimum_delay: int = 6

var future_land_lag: int = 3

func enter(_msg := {}) -> void:
	super()
	future_land_lag = 3
	if _msg["PreviousState"] == "FullHop":
		future_land_lag = 6

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	if input_converter.stick_position.y < 0:
		character.physics_parameters.is_fastfalling = true
	super(_delta)
	if character.is_on_floor():
		state_machine.transition_to("Land")
	if Buffer.is_action_press_buffered("jump") && character.physics_parameters.can_double_jump && frame_count > dj_minimum_delay:
		state_machine.transition_to("DoubleJump")

func exit() -> void:
	pass
