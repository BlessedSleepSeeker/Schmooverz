extends Node
# Keeps track of recent inputs in order to make timing windows more flexible.
# Intended use: Add this file to your project as an Autoload script and have other objects call the class' methods.
# (more on AutoLoad: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

# How many milliseconds ahead of time the player can make an input and have it still be recognized.
# 1000 ms per second, divided by the 60 frames per second. Multiplied by the numbers of frames I want to buffer for
var one_frame_duration: float = (1000.0 / 60.0)
var BUFFER_WINDOW: float = one_frame_duration * 6
# The godot default deadzone is 0.2 so I chose to have it the same
const JOY_DEADZONE: float = 0.2

var keyboard_timestamps: Dictionary = {}
var joypad_timestamps: Dictionary = {}

var disabled_actions: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	

func register_actions_press() -> void:
	pass

# Called whenever the player makes an input.
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if !event.pressed or event.is_echo():
			return

		var scancode: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
		keyboard_timestamps[scancode] = Time.get_ticks_msec()
	elif event is InputEventJoypadButton:
		if !event.pressed or event.is_echo():
			return
			
		var button_index: int = event.button_index
		joypad_timestamps[button_index] = Time.get_ticks_msec()
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) < JOY_DEADZONE:
			return

		var axis_code: String = str(event.axis) + "_" + str(sign(event.axis_value))
		joypad_timestamps[axis_code] = Time.get_ticks_msec()
	
	handle_cstick()


# Returns whether any of the keyboard keys or joypad buttons in the given action were pressed within the buffer window.
func is_action_press_buffered(action: String) -> bool:
	# Get the inputs associated with the action. If any one of them was pressed in the last BUFFER_WINDOW milliseconds,
	# the action is buffered.
	if disabled_actions.has(action):
		return false
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var scancode: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
			if keyboard_timestamps.has(scancode):
				if Time.get_ticks_msec() - keyboard_timestamps[scancode] <= BUFFER_WINDOW:
					# Prevent this method from returning true repeatedly and registering duplicate actions.
					return true

		elif event is InputEventJoypadButton:
			var button_index: int = event.button_index
			if joypad_timestamps.has(button_index):
				var delta = Time.get_ticks_msec() - joypad_timestamps[button_index]
				if delta <= BUFFER_WINDOW:
					return true

		elif event is InputEventJoypadMotion:
			if abs(event.axis_value) < JOY_DEADZONE:
				return false
			var axis_code: String = str(event.axis) + "_" + str(sign(event.axis_value))
			if joypad_timestamps.has(axis_code):
				var delta = Time.get_ticks_msec() - joypad_timestamps[axis_code]
				if delta <= BUFFER_WINDOW:
					return true
	# If there's ever a third type of buffer-able action (mouse clicks maybe?), it'd probably be worth it to generalize
	# the repetitive keyboard/joypad code into something that works for any input method. Until then, by the YAGNI
	# principle, the repetitive stuff stays >:)
	
	return false

func disable_action(action: String) -> void:
	if not disabled_actions.has(action):
		disabled_actions.append(action)

func enable_action(action: String) -> void:
	disabled_actions.remove_at(disabled_actions.find(action))

# Records unreasonable timestamps for all the inputs in an action. Called when IsActionPressBuffered returns true, as
# otherwise it would continue returning true every frame for the rest of the buffer window.
func _invalidate_action(action: String) -> void:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var scancode: int = event.keycode if event.keycode != 0 else event.physical_keycode
			if keyboard_timestamps.has(scancode):
				keyboard_timestamps[scancode] = 0
		elif event is InputEventJoypadButton:
			var button_index: int = event.button_index
			if joypad_timestamps.has(button_index):
				joypad_timestamps[button_index] = 0
		elif event is InputEventJoypadMotion:
			var axis_code: String = str(event.axis) + "_" + str(sign(event.axis_value))
			if joypad_timestamps.has(axis_code):
				joypad_timestamps[axis_code] = 0


func handle_cstick(input_action_mode: String = "attack"):
	var stick_pos: Vector2 = Vector2.ZERO
	stick_pos.x = Input.get_axis("cstick_left", "cstick_right")
	stick_pos.y = Input.get_axis("cstick_down", "cstick_up")
	if stick_pos != Vector2.ZERO:
		for event in InputMap.action_get_events(input_action_mode):
			if event is InputEventKey:
				var scancode: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
				keyboard_timestamps[scancode] = Time.get_ticks_msec()
