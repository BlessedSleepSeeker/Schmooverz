extends Node3D
class_name BaseStateMachine

signal transitioned(state_name)

@export var initial_state := NodePath()

@onready var state: BaseEntityState = get_node(initial_state)

var hitpause_frames_left: int = 0

func _ready() -> void:
	await owner.ready
	for child in get_children():
		if child is BaseEntityState:
			child.state_machine = self
			child.control_interface = owner.control_interface
	state.enter()

func _input(event: InputEvent) -> void:
	if hitpause_frames_left == 0:
		state.input(event)

func _unhandled_input(event: InputEvent) -> void:
	if hitpause_frames_left == 0:
		state.unhandled_input(event)

func _process(delta: float) -> void:
	if hitpause_frames_left == 0:
		state.update(delta)

func _physics_process(delta: float) -> void:
	if hitpause_frames_left == 0:
		state.physics_update(delta)
	else:
		hitpause_frames_left -= 1

func flip_states(direction: bool) -> void:
	for child in get_children():
		if child is BaseEntityState:
			child.flip_hitboxes(direction)

func add_hitpause(frame_amount: int) -> void:
	hitpause_frames_left += frame_amount

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		push_error("No State with Name {%s} was found in entity %s" % [target_state_name, owner])
		return
	msg["PreviousState"] = state.name
	state.exit()
	state = get_node(target_state_name)
	FramePrint.prt("[color=red]%s[/color] : Entering %s with dict %s" % [owner.name, state.name, msg])
	state.enter(msg)
	transitioned.emit(state.name)
