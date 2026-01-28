extends BaseStateMachine
class_name StateMachine

func _ready() -> void:
	await owner.ready
	for child in get_children():
		if child is CharacterState:
			child.state_machine = self
			child.input_converter = owner.input_converter
	for child in get_children():
		if child is CharacterState:
			if child.name == "Shield":
				child.shield_life_updated.connect(owner.debug_hud.update_shield)
				child.shield_life_updated.connect(owner.skin.shield_vfx.update_shield_health)
	state.enter()

func _input(event: InputEvent) -> void:
	super(event)

func _unhandled_input(event: InputEvent) -> void:
	super(event)

func _process(delta: float) -> void:
	super(delta)

func _physics_process(delta: float) -> void:
	super(delta)
	owner.debug_hud.update_state(state.name, state.frame_count, state.set_frame_duration)
	owner.debug_hud.update_position(owner.global_position, owner.velocity)

func flip_states(direction: bool) -> void:
	for child in get_children():
		if child is CharacterState:
			child.flip_hitboxes(direction)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		push_error("No State with Name {%s} was found" % [target_state_name])
		return
	msg["PreviousState"] = state.name
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	FramePrint.prt("Entering %s with dict %s" % [state.name, msg])
	transitioned.emit(state.name)
