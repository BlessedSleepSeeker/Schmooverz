extends CollisionShape3D
class_name Hitbox

## In percents
@export var damage: float = 2
## In Degrees
@export var knockback_angle: float = 45
@export var knockback_base: float = 4.0
@export var knockback_scaling: float = 0.0

@export var string_template: String = "%s [%.1f, %f, %.2f, %.2f]"

func _to_string() -> String:
	return string_template % [name, damage, knockback_angle, knockback_base, knockback_scaling]