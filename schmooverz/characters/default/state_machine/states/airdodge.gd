extends CharacterStateFrames

@export var base_endlag: int = 20
@export var endlag_on_land: int = 8

var should_snap: bool = false

func _ready():
	self.endlag = base_endlag
	super()

func enter(_msg = {}):
	super()
	character.velocity = calculate_airdodge_vector() * character.physics_parameters.AIRDODGE_SPEED
	if character.should_snap:
		should_snap = true
	if not character.register_should_snap.is_connected(_should_snap):
		character.register_should_snap.connect(_should_snap)
	Buffer.disable_action("shield")

func during_startup() -> void:
	pass

func during_active_frame(_index: int) -> void:
	move_x_toward_by_frame(Vector3.ZERO, character.physics_parameters.AIRDODGE_FRICTION)
	move_y_toward_by_frame(Vector3.ZERO, character.physics_parameters.AIRDODGE_FRICTION)

func during_inactive_frame(_index: int) -> void:
	move_x_toward_by_frame(Vector3.ZERO, character.physics_parameters.AIRDODGE_FRICTION)
	move_y_toward_by_frame(Vector3.ZERO, character.physics_parameters.AIRDODGE_FRICTION)

func during_endlag() -> void:
	move_x_toward_by_frame(Vector3.ZERO, character.physics_parameters.AIRDODGE_FRICTION)
	move_y_toward_by_frame(Vector3.ZERO, character.physics_parameters.AIRDODGE_FRICTION)

func calculate_airdodge_vector() -> Vector3:
	var airdodge_vector: Vector3 = Vector3.ZERO
	var stick_vector: Vector2 = input_converter.get_cardinal_direction_from_stick()

	airdodge_vector.x = stick_vector.x
	airdodge_vector.y = stick_vector.y
	return airdodge_vector

func _should_snap() -> void:
	should_snap = true

func snap_character_to_platform(_delta: float) -> void:
	FramePrint.prt(should_snap)
	if should_snap && character.snap_to:
		character.global_position.y = character.snap_to.global_position.y + 0.1
		character.velocity.y = -1.6
		self.endlag = endlag_on_land
		should_snap = false
		state_machine.transition_to("Land", {"landing_lag": self.endlag})
		# var saved_velocity_x: float = character.velocity.x
		# character.velocity.x = 0
		# character.move_and_slide()
		# character.velocity.x = saved_velocity_x


func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	snap_character_to_platform(_delta)
	super(_delta)
	if not character.is_airborne():
		self.endlag = endlag_on_land
		state_machine.transition_to("Land", {"landing_lag": self.endlag})
	if endlag == endlag_on_land && character.is_airborne():
		state_machine.transition_to("Fall")

func exit():
	if character.register_should_snap.is_connected(_should_snap):
		character.register_should_snap.disconnect(_should_snap)
	should_snap = false
	endlag = base_endlag
	Buffer.enable_action("shield")

func on_frame_count_reached():
	if character.is_airborne():
		state_machine.transition_to("Fall")
	else:
		state_machine.transition_to("Idle")

func _notification(_what):
	pass
