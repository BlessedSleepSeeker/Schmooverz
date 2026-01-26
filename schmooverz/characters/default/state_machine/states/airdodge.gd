extends CharacterStateFrames

@export var endlag_on_land: int = 8

var snap_to: Node3D = null
var should_snap: bool = false:
	set(value):
		should_snap = value

func enter(_msg = {}):
	super()
	character.velocity = calculate_airdodge_vector() * character.physics_parameters.AIRDODGE_SPEED
	if not character.airdodge_snap_area.body_entered.is_connected(toggle_snap.bind(true)):
		character.airdodge_snap_area.body_entered.connect(toggle_snap.bind(true))
	if not character.airdodge_snap_area.body_exited.is_connected(toggle_snap.bind(false)):
		character.airdodge_snap_area.body_exited.connect(toggle_snap.bind(false))

func toggle_snap(body: Node3D, value: bool) -> void:
	should_snap = value
	snap_to = body


func during_startup() -> void:
	pass

func during_active_frame() -> void:
	move_x_toward_by_frame(Vector3.ZERO, character.physics_parameters.AIRDODGE_FRICTION)
	move_y_toward_by_frame(Vector3.ZERO, character.physics_parameters.AIRDODGE_FRICTION)

func during_inactive_frame() -> void:
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

func snap_character_to_platform() -> void:
	if should_snap && snap_to:
#		FramePrint.prt("SNAPPING !")
#		FramePrint.prt(character.global_position.y)
		character.global_position.y = snap_to.global_position.y + 0.1
		character.velocity.y = -0.1
		self.endlag = endlag_on_land
		should_snap = false
		state_machine.transition_to("Land", {"landing_lag": self.endlag})
#		FramePrint.prt(character.global_position.y)

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	snap_character_to_platform()
	super(_delta)
	if not character.is_airborne():
		self.endlag = endlag_on_land
		state_machine.transition_to("Land", {"landing_lag": self.endlag})
	if endlag == endlag_on_land && character.is_airborne():
		state_machine.transition_to("Fall")

func exit():
	pass

func on_frame_count_reached():
	if character.is_airborne():
		state_machine.transition_to("Fall")
	else:
		state_machine.transition_to("Idle")

func _notification(_what):
	pass
