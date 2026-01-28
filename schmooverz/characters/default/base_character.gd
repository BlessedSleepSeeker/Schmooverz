extends BasePlatfighterEntity
class_name CharacterInstance

@onready var ground_collision: CollisionShape3D = %GroundCollision
@onready var input_converter: InputConverter = %InputConverter
@onready var debug_hud: CharacterDebugHUD = %DebugLayer
# @onready var particles_manager: ParticlesManager = %ParticlesManager
@onready var airdodge_snap_area: Area3D = %PlatformAirdodgeSnapArea

var snap_to: Node3D = null
var should_snap: bool = false:
	set(value):
		should_snap = value

signal platdrop
signal register_should_snap

func _ready():
	state_machine = %StateMachine
	skin = %CharacterSkin
	orient_skin()
	if not airdodge_snap_area.body_entered.is_connected(toggle_waveland_snap.bind(true)):
		airdodge_snap_area.body_entered.connect(toggle_waveland_snap.bind(true))
	if not airdodge_snap_area.body_exited.is_connected(toggle_waveland_snap.bind(false)):
		airdodge_snap_area.body_exited.connect(toggle_waveland_snap.bind(false))

func toggle_waveland_snap(body: Node3D, value: bool) -> void:
	should_snap = value
	snap_to = body
	if should_snap:
		register_should_snap.emit()
	debug_hud.update_snap(should_snap)
