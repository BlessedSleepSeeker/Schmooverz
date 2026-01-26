extends Node3D
class_name Level

@onready var player: CharacterInstance = %BaseCharacter

func _ready():
	add_player_ref()

func add_player_ref() -> void:
	for node in get_tree().get_nodes_in_group("NeedPlayerRef"):
		node.player = player