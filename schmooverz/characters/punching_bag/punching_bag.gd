extends CharacterBody3D
class_name BaseEntity

@export var physics_parameters: CharacterPhysics = CharacterPhysics.new()

var percent: float = 0

func _physics_process(_delta):
	move_and_slide()

func calculate_knockback(hitbox: Hitbox) -> Vector3:
	var knockback_angle: Vector3 = Vector3.ZERO


	return knockback_angle

func hit(hitbox: Hitbox) -> void:
	self.percent += hitbox.damage
	self.velocity = calculate_knockback(hitbox)