extends CharacterBody3D
class_name CharacterInstance


@export var physics_parameters: CharacterPhysics = CharacterPhysics.new()

@onready var state_machine: StateMachine = $StateMachine
@onready var ground_collision: CollisionShape3D = %GroundCollision
@onready var skin: CharacterSkin = %CharacterSkin
@onready var input_converter: InputConverter = %InputConverter
@onready var debug_hud: CharacterDebugHUD = %DebugLayer
# @onready var particles_manager: ParticlesManager = %ParticlesManager

var direction: Vector3 = Vector3.ZERO
var raw_input: float = 0.0

## true == right,
## false == left
var facing_direction: bool = true:
	set(value):
		facing_direction = value

signal platdrop


func _ready():
	orient_skin()

func play_animation(animation_name: String) -> void:
	skin.travel(animation_name)

func is_airborne() -> bool:
	return not self.is_on_floor()

func orient_skin() -> void:
	skin.look_to(facing_direction)
