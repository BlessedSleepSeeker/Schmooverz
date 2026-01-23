extends CanvasLayer
class_name CharacterDebugHUD

@export var frame_template: String = "Total Time/Frame [%.03f:%d]"
@export var state_template: String = "%s [%d/%d]"
@export var shield_template: String = "Shield Health [%.03f/%.03f]"
@export var position_template: String = "Position = [%.04f:%.04f] (%.04f:%.04f)"

@onready var frame_label: RichTextLabel = %FrameLabel
@onready var state_label: RichTextLabel = %StateLabel
@onready var shield_label: RichTextLabel = %ShieldLabel
@onready var position_label: RichTextLabel = %PositionLabel

@onready var input_list: RichTextLabel = %InputsList

func update_state(state_name: String, state_frame: int, state_duration: int) -> void:
	state_label.text = state_template % [state_name, state_frame, state_duration]

func update_frame() -> void:
	frame_label.text = frame_template % [FramePrint.total_time_elapsed, FramePrint.total_frames]

func update_shield(shield_life: float, max_value) -> void:
	shield_label.text = shield_template % [shield_life, max_value]

func update_position(player_position: Vector3, player_velocity: Vector3) -> void:
	position_label.text = position_template % [player_position.x, player_position.y, player_velocity.x, player_velocity.y]

func _physics_process(_delta):
	update_frame()
	if get_tree().get_frame() % 60 == 0:
		input_list.text = ""

func _input(event):
	input_list.text += event.as_text() + "\n"
