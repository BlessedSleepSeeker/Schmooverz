extends Node3D
class_name CharacterSkin


@export var play_animation_on_load: String = ""
@export var fishing_rod_models: Array[BoneAttachment3D] = []

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

@onready var center_pivot: Node3D = $CenterPivot

@onready var shield_vfx: ShieldMesh = %ShieldMesh

func _ready():
	if play_animation_on_load:
		travel(play_animation_on_load)

func travel(state_name: String) -> void:
	state_machine.travel(state_name)

func reset_swing_orientation() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation:x", 0, 1)

func look_to(facing_direction: bool) -> void:
	if facing_direction:
		self.rotation_degrees.y = 90
	else:
		self.rotation_degrees.y = -90

func spin(speed: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(center_pivot, "rotation_degrees:x", 360, speed)

func reset_spin() -> void:
	center_pivot.rotation_degrees.x = 0