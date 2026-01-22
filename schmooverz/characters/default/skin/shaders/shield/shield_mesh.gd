extends MeshInstance3D
class_name ShieldMesh

@export var shield_force_amount_full: float = 1
@export var shield_force_amount_empty: float = 0

@onready var shield_shader: ShaderMaterial = self.material_override

func toggle_shield_visibility(shield_visibility: bool) -> void:
	self.visible = shield_visibility

func update_shield_health(health: float, max_health: float = 50) -> void:
	var percent: float = health / max_health
	shield_shader.set_shader_parameter("barrier_force", percent)