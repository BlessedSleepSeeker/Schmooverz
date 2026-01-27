extends CharacterBody3D
class_name BaseEntity

@export var physics_parameters: CharacterPhysics = CharacterPhysics.new()

func _physics_process(_delta):
	move_and_slide()

func hit(hitbox: Hitbox) -> void:
	pass