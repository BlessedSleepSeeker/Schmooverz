@tool
extends StaticBody3D
class_name Platform

@onready var mesh: Mesh = %MeshInstance3D.mesh
@onready var collision_shape: Shape3D = %CollisionShape3D.shape

@export_range(0.1, 100, 0.1) var lenght: float:
	set(value):
		lenght = value
		if mesh:
			mesh.size.x = lenght
		if collision_shape:
			collision_shape.size.x = lenght

var player: CharacterInstance:
	set(value):
		player = value
		if player:
			player.platdrop.connect(allow_platform_drop)

var processing_player_position: bool = true

func _ready():
	lenght = lenght

func allow_platform_drop() -> void:
	processing_player_position = false
	set_mask(false)
	await get_tree().create_timer(0.1).timeout
	processing_player_position = true

func _physics_process(_delta):
	if player && processing_player_position:
		if player.global_position.y < self.global_position.y:
			set_mask(false)
		else:
			set_mask(true)

func set_mask(active_for_player: bool) -> void:
	if active_for_player:
		self.set_collision_layer_value(3, true)
	else:
		self.set_collision_layer_value(3, false)
