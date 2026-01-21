extends CharacterState
class_name FallState

@export var dj_minimum_delay: int = 2
@export var coyote_frames: int = 6
var can_coyote_time: bool = false

func enter(_msg := {}) -> void:
	super()
	# if _msg["PreviousState"] == "Idle" or _msg["PreviousState"] == "Run" or _msg["PreviousState"] == "Walk":
	# 	can_coyote_time = true
	if _msg["PreviousState"] == "Jump":
		frame_count = dj_minimum_delay + 1

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if character.is_on_floor():
		state_machine.transition_to("Land")
	if Buffer.is_action_press_buffered("jump") && frame_count < coyote_frames && can_coyote_time:
		state_machine.transition_to("Jump")
	elif Buffer.is_action_press_buffered("jump") && character.can_double_jump && frame_count > dj_minimum_delay:
		state_machine.transition_to("DoubleJump")

func exit() -> void:
	can_coyote_time = false