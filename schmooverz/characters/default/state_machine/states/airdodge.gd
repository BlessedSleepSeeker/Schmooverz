extends CharacterStateFrames

@export var endlag_on_land: int = 8

func enter(_msg = {}):
	super()
	character.velocity = calculate_airdodge_vector() * character.physics_parameters.AIRDODGE_SPEED

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

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	super(_delta)
	if not character.is_airborne():
		self.endlag = endlag_on_land
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
