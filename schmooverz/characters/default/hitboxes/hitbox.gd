extends CollisionShape3D
class_name Hitbox

enum HitboxType {
	CLASSIC,
	SPECIAL,
	GRAB
}

@export var hitbox_type: HitboxType = HitboxType.CLASSIC
## In percents
@export var damage: float = 2
## In Degrees
@export var knockback_angle: float = 45
@export var knockback_base: float = 4.0
@export var knockback_scaling: float = 0.0

@export_group("Hitpause")
@export var min_hitpause: int = 3
@export var max_hitpause: int = 24
@export var self_hitpause: int = 3
@export var hitpause_multiplier: float = 1

@export_group("Debug")
@export var string_template: String = "%s [%s, %.1f, %f, %.2f, %.2f]"

var is_active: bool = false:
	set(value):
		is_active = value
		# FramePrint.prt("%s IS NOW ACTIVE" % name)
		if is_active:
			trigger_check()

var last_body: Node3D = null:
	set(value):
		last_body = value
		if last_body != null:
			# FramePrint.prt("%s HAS REGISTERED BODY %s" % [name, last_body])
			trigger_check()
		# else:
			# FramePrint.prt("%s UNREGISTERED BODY %s" % [name, last_body])

var sent_trigger_this_activation: bool = false

signal hitbox_triggered(body: Node3D, hitbox: Hitbox)

func _to_string() -> String:
	return string_template % [name, is_active, damage, knockback_angle, knockback_base, knockback_scaling]

func trigger_check() -> void:
	if last_body != null && is_active && not sent_trigger_this_activation:
		hitbox_triggered.emit(last_body, self)
		sent_trigger_this_activation = true