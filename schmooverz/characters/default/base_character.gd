extends CharacterBody3D
class_name CharacterInstance


@onready var state_machine: StateMachine = $StateMachine
@onready var ground_collision: CollisionShape3D = %GroundCollision
@onready var skin: CharacterSkin = %CharacterSkin
@onready var input_converter: InputConverter = %InputConverter
# @onready var particles_manager: ParticlesManager = %ParticlesManager

var direction: Vector3 = Vector3.ZERO
var raw_input: float = 0.0
var can_double_jump: bool = true

func _ready():
	pass

func play_animation(animation_name: String) -> void:
	skin.travel(animation_name)

func is_airborne() -> bool:
	return not self.is_on_floor()

func orient_skin() -> void:
	skin.look_to(self.velocity.x)
