extends CharacterState
class_name LandState

func enter(_msg := {}) -> void:
	super()
	if _msg.has("landing_lag"):
		first_actionable_frame = _msg["landing_lag"]
	character.physics_parameters.can_double_jump = true
	character.physics_parameters.is_fastfalling = false
	character.physics_parameters.can_airdodge = true

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if character.is_airborne():
		state_machine.transition_to("Fall")
	if can_act_out_of_state():
		state_machine.transition_to("Idle")

func on_frame_count_reached() -> void:
	state_machine.transition_to("Idle")

func exit() -> void:
	pass

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST || what == Node.NOTIFICATION_WM_GO_BACK_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)