extends CharacterState
class_name CharacterStateFrames

## Frames amount
@export var startup: int = 1
## Frames amount as [active_window, inactive_window, active_window...]
@export var active_frames: Array[int] = [2]
## Frames amount
@export var endlag: int = 3

func during_startup() -> void:
	pass

func during_active_frame() -> void:
	pass

func during_inactive_frame() -> void:
	pass

func during_endlag() -> void:
	pass

func count_active_frames() -> int:
	var total_actives: int = 0
	for frames: int in active_frames:
		total_actives += frames
	return total_actives

func get_current_active_window(frame_number: int) -> int:
	var full_count = startup
	var index: int = 0
	for window in active_frames:
		for i in range(window):
			full_count += 1
			if full_count == frame_number:
				return index
		index += 1
	push_error("Frame is not in active frames windows.")
	return -1

func frame_dispatcher() -> void:
	if frame_count >= startup + count_active_frames() + endlag:
		on_frame_count_reached()
	elif frame_count < startup:
		during_startup()
	elif frame_count >= startup + count_active_frames():
		during_endlag()
	else:
		var window_index: int = get_current_active_window(frame_count)
		if window_index % 2 == 0:
			during_active_frame()
		else:
			during_inactive_frame()

func enter(_msg = {}):
	super()

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	frame_dispatcher()
	super(_delta)

func exit():
	pass

func on_frame_count_reached():
	pass

func _notification(_what):
	pass
