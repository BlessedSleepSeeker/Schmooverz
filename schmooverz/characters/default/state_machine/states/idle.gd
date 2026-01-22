extends CharacterState
class_name IdleState

@export var min_loop_before_fidget: int = 1
@export var fidget_chance: int = 50
var current_loop: int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func enter(_msg := {}) -> void:
	current_loop = 0
	super()

func roll_for_fidget(_finished_animation: String):
	if current_loop >= min_loop_before_fidget && fidget_chance >= rng.randi_range(1, 100):
		play_animation("IdleFidget")
		current_loop = 0
	else:
		play_animation()
		current_loop += 1

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	character.direction.x = input_converter.stick_position.x

	if input_converter.stick_position.x == 0.0:
		character.velocity = character.velocity.move_toward(character.direction * character.physics_parameters.MAX_SPEED, character.physics_parameters.FRICTION * _delta)
	else:
		character.velocity = character.velocity.move_toward(character.direction * character.physics_parameters.MAX_SPEED, character.physics_parameters.ACCELERATION * _delta)
	super(_delta)
	if character.is_airborne():
		state_machine.transition_to("Fall")
	if input_converter.stick_position.x < 0:
		state_machine.transition_to("Dash", {"direction": "left"})
		return
	if input_converter.stick_position.x > 0:
		state_machine.transition_to("Dash", {"direction": "right"})
		return
	if input_converter.stick_position.y < 0:
		state_machine.transition_to("CrouchStart")

	if input_converter.can_trigger_action("jump"):
		state_machine.transition_to("JumpSquat")

	if input_converter.can_trigger_action("jab"):
		state_machine.transition_to("Jab")
	if input_converter.can_trigger_action("uspec"):
		state_machine.transition_to("USpec")

	if input_converter.can_trigger_action("shield"):
		state_machine.transition_to("Shield")
	if input_converter.can_trigger_action("roll_left"):
		state_machine.transition_to("RollLeft")
	if input_converter.can_trigger_action("roll_right"):
		state_machine.transition_to("RollRight")

func exit() -> void:
	pass

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST || what == Node.NOTIFICATION_WM_GO_BACK_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
