extends CharacterBody3D
class_name BasePlatfighterEntity

@export var percents: float = 0
@export var physics_parameters: CharacterPhysics = CharacterPhysics.new()

@onready var state_machine: BaseStateMachine
@onready var skin: CharacterSkin

var knockback_velocity: Vector3 = Vector3.ZERO

## true == right,
## false == left
var facing_direction: bool = true:
	set(value):
		facing_direction = value
		state_machine.flip_states(facing_direction)

func _ready():
	state_machine = %StateMachine

#region Functions
func play_animation(animation_name: String) -> void:
	if skin:
		skin.travel(animation_name)

func orient_skin() -> void:
	if skin:
		skin.look_to(facing_direction)

func _physics_process(_delta):
	self.velocity.z = 0

func is_airborne() -> bool:
	return not self.is_on_floor()
#region Knockback
func calculate_knockback(hitbox: Hitbox, flip_angle_x: bool) -> Vector3:
	var kb_angle: Vector3 = calculate_normalized_knockback_angle(hitbox, flip_angle_x)
	var kb_strenght: float = calculate_knockback_strenght(hitbox)
	return kb_angle * kb_strenght

func calculate_normalized_knockback_angle(hitbox: Hitbox, flip_angle_x) -> Vector3:
	var kb_angle_v2: Vector2 = rotation_to_direction(hitbox.knockback_angle)
	var knockback_angle: Vector3 = Vector3(kb_angle_v2.x, kb_angle_v2.y, 0)
	if flip_angle_x:
		knockback_angle.x *= -1
	return knockback_angle

func calculate_knockback_strenght(hitbox: Hitbox) -> float:
	var weight_multiplier: float = 200.0 / (self.physics_parameters.WEIGHT + 100)
	var kb_velocity: float = 3 * (hitbox.knockback_base + (hitbox.knockback_scaling * 0.12 * self.percents * weight_multiplier))
	return kb_velocity

func rotation_to_direction(_rotation_degrees: float) -> Vector2:
	# Convert rotation from degrees to radians (skip if already in radians)
	var rotation_radians = deg_to_rad(_rotation_degrees)
	# Calculate direction vector
	var direction = Vector2(cos(rotation_radians), sin(rotation_radians))
	# Normalize the vector (optional, but ensures length = 1)
	direction = direction.normalized()
	return direction

#endregion

#region Hitpause & Hitstun
func calculate_hitpause(hitbox: Hitbox) -> int:
	return clampi(ceili(hitbox.damage * hitbox.hitpause_multiplier), hitbox.min_hitpause, hitbox.max_hitpause)

func calculate_hitstun(hitbox: Hitbox) -> int:
	return ceili(calculate_knockback_strenght(hitbox) * (4.07/3))

#endregion

func hit(hitbox: Hitbox, flip_angle_x: bool) -> void:
	self.percents += hitbox.damage
	self.velocity = Vector3.ZERO
	self.knockback_velocity = calculate_knockback(hitbox, flip_angle_x)
	if state_machine:
		state_machine.add_hitpause(calculate_hitpause(hitbox))
		state_machine.transition_to("Hitstun", {
			"hitstun_duration": calculate_hitstun(hitbox)
		})
