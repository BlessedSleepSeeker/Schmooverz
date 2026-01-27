extends CharacterBody3D
class_name CharacterInstance


@export var physics_parameters: CharacterPhysics = CharacterPhysics.new()

@onready var state_machine: StateMachine = $StateMachine
@onready var ground_collision: CollisionShape3D = %GroundCollision
@onready var skin: CharacterSkin = %CharacterSkin
@onready var input_converter: InputConverter = %InputConverter
@onready var debug_hud: CharacterDebugHUD = %DebugLayer
# @onready var particles_manager: ParticlesManager = %ParticlesManager

@onready var airdodge_snap_area: Area3D = %PlatformAirdodgeSnapArea

var direction: Vector3 = Vector3.ZERO
var raw_input: float = 0.0

## true == right,
## false == left
var facing_direction: bool = true:
	set(value):
		facing_direction = value
		state_machine.flip_states(facing_direction)

var snap_to: Node3D = null
var should_snap: bool = false:
	set(value):
		should_snap = value

signal platdrop
signal register_should_snap

func _ready():
	orient_skin()
	if not airdodge_snap_area.body_entered.is_connected(toggle_waveland_snap.bind(true)):
		airdodge_snap_area.body_entered.connect(toggle_waveland_snap.bind(true))
	if not airdodge_snap_area.body_exited.is_connected(toggle_waveland_snap.bind(false)):
		airdodge_snap_area.body_exited.connect(toggle_waveland_snap.bind(false))

func play_animation(animation_name: String) -> void:
	skin.travel(animation_name)

func is_airborne() -> bool:
	return not self.is_on_floor()

func toggle_waveland_snap(body: Node3D, value: bool) -> void:
	should_snap = value
	snap_to = body
	if should_snap:
		register_should_snap.emit()
	debug_hud.update_snap(should_snap)

func orient_skin() -> void:
	skin.look_to(facing_direction)

func _physics_process(_delta):
	self.velocity.z = 0
