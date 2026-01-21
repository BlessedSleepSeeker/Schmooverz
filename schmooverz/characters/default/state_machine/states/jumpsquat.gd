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
	if Buffer.is_action_press_buffered("attack"):
		state_machine.transition_to("AttackDispatcher")
	if Buffer.is_action_press_buffered("shield"):
		state_machine.transition_to("Shield")

func exit() -> void:
	pass

func on_frame_count_reached() -> void:
	state_machine.transition_to("Jump")

func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_WM_CLOSE_REQUEST || what == Node.NOTIFICATION_WM_GO_BACK_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)