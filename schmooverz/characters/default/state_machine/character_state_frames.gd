extends CharacterState
class_name CharacterStateFrames

## Frames amount
@export var startup: int = 1
## Frames amount as [active_window, inactive_window, active_window...]
@export var active_frames: Array[int] = [2]
## Frames amount
@export var endlag: int = 3

func _count_active_frames() -> int:
	var total_actives: int = 0
	for frames: int in active_frames:
		total_actives += frames
	return total_actives

func _get_current_active_window(frame_number: int) -> int:
	var full_count = startup
	var index: int = 0
	for window in active_frames:
		for i in range(window):
			full_count += 1
			if full_count == frame_number:
				return index
		index += 1
	push_error("Frame %d is not in active frames windows." % frame_number)
	return -1

func _frame_dispatcher() -> void:
	if frame_count >= startup + _count_active_frames() + endlag:
		on_frame_count_reached()
	elif frame_count <= startup:
		during_startup()
	elif frame_count >= startup + _count_active_frames():
		during_endlag()
	else:
		var window_index: int = _get_current_active_window(frame_count)
		if window_index % 2 == 0:
			during_active_frame(window_index)
		else:
			during_inactive_frame(window_index)

func during_startup() -> void:
	pass

func during_active_frame(_index: int) -> void:
	pass

func during_inactive_frame(_index: int) -> void:
	pass

func during_endlag() -> void:
	pass

func enter(_msg = {}):
	super()

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	_frame_dispatcher()
	super(_delta)

func exit():
	pass

func on_frame_count_reached():
	pass

func _notification(_what):
	pass
