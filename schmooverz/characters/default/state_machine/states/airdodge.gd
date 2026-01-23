extends CharacterState

func enter(_msg = {}):
	super()

func calculate_airdodge_vector() -> Vector3:
	var airdodge_vector: Vector3 = Vector3.ZERO
	FramePrint.prt(input_converter.get_cardinal_direction_from_stick())

	return airdodge_vector

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	super(_delta)

func exit():
	pass

func on_frame_count_reached():
	pass

func _notification(_what):
	pass
