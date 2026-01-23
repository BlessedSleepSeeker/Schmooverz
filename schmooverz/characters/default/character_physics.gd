extends Resource
class_name CharacterPhysics

#region Aerials
@export_group("Aerial Movement")
@export var GRAVITY: float = 1.55
## cm/f
@export var MAX_FALL_SPEED: float = 28.3
## cm/f
@export var MAX_FAST_FALL_SPEED: float = 36.25
@export_subgroup("Air Drift")
## cm/f
@export var MAX_HORIZONTAL_AIR_SPEED: float = 15.0
## cm/f**2
@export var AIR_ACCELERATION: float = 0.7
## cm/f**2
@export var AIR_FRICTION: float = 0.17
@export_subgroup("Jumps")
## cm/f
@export var SHORT_HOP_IMPULSE: float = 21.5
## cm
@export var SHORT_HOP_MAX_HEIGHT: float = 138.45
## cm/f
@export var FULL_HOP_IMPULSE: float = 32.0
## cm
@export var FULL_HOP_MAX_HEIGHT: float = 324.5
@export var DOUBLE_JUMP_IMPULSE: float = 29
#endregion


#region Grounded
@export_group("Grounded Movement")
# Frames
@export var DASH_DURATION: int = 16
# cm/f
@export var DASH_INITIAL_SPEED: float = 22
# cm/f
@export var DASH_CURVE: Curve = Curve.new()
@export var MAX_RUN_SPEED: float = 25.5
@export var RUN_TURNAROUND_DURATION: int = 20
@export var RUN_TURNAROUND_ACCELERATION: float = 3
@export var GROUND_ACCELERATION: float = 20
# cm/f**2. Higher Value == slows down faster
@export var GROUND_FRICTION: float = 1.0
#endregion

#region Defensive
@export_group("Defensive")
@export var WEIGHT: int = 82
@export var HITSTUN_GRAVITY: float = 1.55
@export var AIRDODGE_INITIAL_SPEED: float = 27
@export var AIRDODGE_FRICTION: float = 1.5
@export var ROLL_INITIAL_SPEED: float = 26.5

var is_fastfalling: bool = false
var can_double_jump: bool = true