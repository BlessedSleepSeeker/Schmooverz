extends CharacterState
class_name JumpSquatState

func enter(_msg := {}) -> void:
	super()

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta: float, _move_character: bool = true) -> void:
	super(_delta)
	if character.is_airborne():
		state_machine.transition_to("Fall")
	if input_converter.can_trigger_action("uspec"):
		state_machine.transition_to("USpec")

func exit() -> void:
	pass

func on_frame_count_reached() -> void:
	if Input.is_action_pressed("jump"):
		state_machine.transition_to("FullHop")
	else:
		state_machine.transition_to("ShortHop")

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST || what == Node.NOTIFICATION_WM_GO_BACK_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)