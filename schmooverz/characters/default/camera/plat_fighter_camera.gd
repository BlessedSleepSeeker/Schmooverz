extends Node3D
class_name FollowLimitsCamera

@export_node_path("CharacterInstance") var focus: NodePath
@export var pos_x_limit: float = 5
@export var neg_x_limit: float = 5
@export var pos_y_limit: float = 2
@export var neg_y_limit: float = 3

@export var camera_speed: Vector2 = Vector2(10, 10)


@onready var focused_node: Node3D = get_node(focus)

func _process(delta):
	if self.global_position.x + pos_x_limit < focused_node.global_position.x || self.global_position.x - neg_x_limit > focused_node.global_position.x:
		self.global_position.x = move_toward(self.global_position.x, focused_node.global_position.x, camera_speed.x * delta)

	if self.global_position.y + pos_y_limit < focused_node.global_position.y || self.global_position.y - neg_y_limit > focused_node.global_position.y:
		self.global_position.y = move_toward(self.global_position.y, focused_node.global_position.y, camera_speed.y * delta)
