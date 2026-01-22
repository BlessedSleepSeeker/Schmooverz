extends Node
class_name InputConverter

## Used to convert buffered inputs (and combinations) to gameplay actions

@export var input_actions: Array[String] = [
	"attack",
	"special",
	"shield",
	"jump"
]

@export var gameplay_actions: Array[GameplayAction] = [
	preload("res://characters/default/state_machine/gameplay_actions/dash_attack.tres"),
	preload("res://characters/default/state_machine/gameplay_actions/ftilt.tres"),
	preload("res://characters/default/state_machine/gameplay_actions/jump.tres"),
	preload("res://characters/default/state_machine/gameplay_actions/jab.tres"),
	preload("res://characters/default/state_machine/gameplay_actions/roll_left.tres"),
	preload("res://characters/default/state_machine/gameplay_actions/roll_right.tres"),
	preload("res://characters/default/state_machine/gameplay_actions/shield.tres"),
	preload("res://characters/default/state_machine/gameplay_actions/uspec.tres"),
]

var stick_position: Vector2 = Vector2.ZERO
var triggerable_actions: Array[GameplayAction] = []

func process_current_movement_stick_position() -> void:
	stick_position = Vector2.ZERO
	stick_position.x = Input.get_axis("ui_left", "ui_right")
	stick_position.y = Input.get_axis("ui_down", "ui_up")

func aggregate_actions() -> Array[String]:
	var current_input_actions: Array[String]
	for input_action: String in input_actions:
		if Buffer.is_action_press_buffered(input_action):
			current_input_actions.append(input_action)
	return current_input_actions

func process_triggerable_actions(stick_pos: Vector2, current_input_actions: Array[String]) -> Array[GameplayAction]:
	triggerable_actions = []
	for action: GameplayAction in gameplay_actions:
		if action.can_action_trigger(stick_pos, current_input_actions):
			triggerable_actions.append(action)
	return triggerable_actions

func can_trigger_action(action_name: String) -> bool:
	for gameplay_action: GameplayAction in triggerable_actions:
		if gameplay_action.name == action_name:
			return true
	return false

func _physics_process(_delta):
	process_current_movement_stick_position()
	process_triggerable_actions(stick_position, aggregate_actions())