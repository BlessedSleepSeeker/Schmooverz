extends Resource
class_name CharacterPhysics

@export_group("Aerial Movement")
@export var GRAVITY: float = 1.2
@export var SHORT_HOP_IMPULSE: float = 19
@export var SHORT_HOP_MAX_HEIGHT: float = 22.0
@export var FULL_HOP_IMPULSE: float = 27
@export var DOUBLE_JUMP_IMPULSE: float = 29
@export var MAX_FALL_SPEED: float = 12
@export var FAST_FALL_SPEED: float = 90

@export_group("Grounded Movement")
# Frames
@export var DASH_DURATION: int = 16
# cm/f
@export var DASH_SPEED: float = 12
# cm/f
@export var DASH_CURVE: Curve = Curve.new()
@export var MAX_RUN_SPEED: float = 8
@export var RUN_TURNAROUND_DURATION: int = 20
@export var RUN_TURNAROUND_ACCEL: float = 5


@export var GROUND_ACCELERATION: float = 20
# cm/f**2. Higher Value == slows down faster
@export var GROUND_FRICTION: float = 40
