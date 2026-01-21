extends CharacterState
class_name DashState

var dash_direction: bool = false

func enter(_msg := {}) -> void:
	super()
	if _msg["direction"] == "right":
		dash_direction = true
	else:
		dash_direction = false

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	character.velocity.x = physics_parameters.DASH_SPEED if dash_direction else -physics_parameters.DASH_SPEED
	super(_delta)
	if character.is_airborne():
		state_machine.transition_to("Fall")
	if input_converter.stick_position.x < 0 && dash_direction:
		state_machine.transition_to("Dash", {"direction": "left"})
		return
	if input_converter.stick_position.x > 0 && not dash_direction:
		state_machine.transition_to("Dash", {"direction": "right"})
		return
	if input_converter.stick_position.y < 0:
		state_machine.transition_to("Crouch")
	
	if input_converter.can_trigger_action("jump"):
		state_machine.transition_to("JumpSquat")
	if input_converter.can_trigger_action("dash_attack"):
		state_machine.transition_to("DashAttack")
	if input_converter.can_trigger_action("shield"):
		state_machine.transition_to("Shield")
	

func on_frame_count_reached() -> void:
	state_machine.transition_to("Run")

func exit() -> void:
	FramePrint.prt("Current X Speed : %s" % character.velocity.x)

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST || what == Node.NOTIFICATION_WM_GO_BACK_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)