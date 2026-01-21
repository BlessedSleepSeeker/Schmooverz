extends Resource
class_name GameplayAction

@export var name: String = ""
@export var button_inputs: Array[String] = []
@export var direction_matter: bool = true
@export var min_direction_input: Vector2 = Vector2.ZERO
@export var max_direction_input: Vector2 = Vector2.ZERO

func can_action_trigger(stick_pos: Vector2, current_input_actions: Array[String]) -> bool:
	var looking_for: Array[bool] = []
	looking_for.resize(button_inputs.size())
	looking_for.fill(false)
	for action: String in button_inputs:
		if not current_input_actions.has(action):
			return false

	if direction_matter:
		if stick_pos.x < min_direction_input.x || stick_pos.x > max_direction_input.x:
			return false
		if stick_pos.y < min_direction_input.y || stick_pos.y > max_direction_input.y:
			return false

	return true

func flush_buffer_for_actions() -> void:
	for input: String in button_inputs:
		Buffer._invalidate_action(input)