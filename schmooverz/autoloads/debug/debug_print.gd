extends Node

var seconds: int = 0
var frame_counter: int = 0
var total_time_elapsed: float = 0
var total_frames: int = 0

var frame_print_template: String = "[color=green][%d:%d][/color] : %s"

func _physics_process(_delta):
	frame_counter += 1
	total_frames += 1
	total_time_elapsed += _delta
	if frame_counter == 60:
		frame_counter = 0
		seconds += 1

func prt(to_print: Variant, with_debug: bool = false) -> void:
	print_rich(frame_print_template % [seconds, frame_counter, str(to_print)])
	if with_debug:
		print_debug("")