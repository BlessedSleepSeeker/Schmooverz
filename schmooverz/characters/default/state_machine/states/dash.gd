extends CharacterState
class_name DashState

var dash_direction: bool = false

func enter(_msg := {}) -> void:
	self.set_frame_duration = character.physics_parameters.DASH_DURATION
	super()
	if _msg["direction"] == "right":
		dash_direction = true
		character.facing_direction = true
	else:
		dash_direction = false
		character.facing_direction = false
	character.orient_skin()
	character.velocity.x = character.physics_parameters.DASH_INITIAL_SPEED if dash_direction else -character.physics_parameters.DASH_INITIAL_SPEED

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	#var sample_percent: float = character.physics_parameters.DASH_CURVE.sample(float(self.frame_count) / self.set_frame_duration)
	#print("%d / %d = %d (%f)" % [self.frame_count, self.set_frame_duration, float(self.frame_count)/self.set_frame_duration, sample_percent])
	character.velocity.x = lerpf(character.physics_parameters.DASH_INITIAL_SPEED, character.physics_parameters.MAX_RUN_SPEED, float(self.frame_count) / self.set_frame_duration)
	if not dash_direction:
		character.velocity.x *= -1
	super(_delta)
	if input_converter.stick_position.x < 0 && dash_direction:
		state_machine.transition_to("Dash", {"direction": "left"})
	if input_converter.stick_position.x > 0 && not dash_direction:
		state_machine.transition_to("Dash", {"direction": "right"})
	if input_converter.can_trigger_action("jump"):
		state_machine.transition_to("JumpSquat")

	if input_converter.can_trigger_action("dash_attack"):
		state_machine.transition_to("DashAttack")
	if input_converter.can_trigger_action("uspec"):
		state_machine.transition_to("USpec")

	if input_converter.can_trigger_action("shield"):
		state_machine.transition_to("Shield")

	if character.is_airborne():
		state_machine.transition_to("Fall")
	

func on_frame_count_reached() -> void:
	state_machine.transition_to("Run")

func exit() -> void:
	pass
	#FramePrint.prt("Current X Speed : %s" % character.velocity.x)

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST || what == Node.NOTIFICATION_WM_GO_BACK_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
