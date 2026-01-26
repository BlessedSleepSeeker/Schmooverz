extends CharacterState
class_name DoubleJumpState

func enter(_msg := {}) -> void:
	super()
	character.physics_parameters.can_double_jump = false
	character.velocity.y = character.physics_parameters.DOUBLE_JUMP_IMPULSE
	character.skin.spin(0.3)

func unhandled_input(_event: InputEvent):
	super(_event)


func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if character.velocity.y <= 0:
		state_machine.transition_to("Fall")
	if input_converter.can_trigger_action("shield"):
		state_machine.transition_to("Airdodge")
	if character.is_on_floor():
		state_machine.transition_to("Land")

func exit() -> void:
	character.skin.reset_spin()
