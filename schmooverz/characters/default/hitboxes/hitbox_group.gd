extends Area3D
class_name HitboxGroup

signal hitbox_triggered(body: Node3D, hitbox: Hitbox)

var is_active: bool = false

func _ready():
	self.body_shape_entered.connect(_on_body_shape_entered)
	self.body_shape_exited.connect(_on_body_shape_exited)
	for hitbox: Hitbox in get_children():
		hitbox.hitbox_triggered.connect(_on_hitbox_triggered)

func _on_body_shape_entered(_body_rid: RID, _body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	var local_shape_owner = shape_find_owner(_local_shape_index)
	var hitbox: Hitbox = shape_owner_get_owner(local_shape_owner)
	if hitbox:
		hitbox.last_body = _body

func _on_body_shape_exited(_body_rid: RID, _body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	var local_shape_owner = shape_find_owner(_local_shape_index)
	var hitbox: Hitbox = shape_owner_get_owner(local_shape_owner)
	if hitbox:
		hitbox.last_body = null

func _on_hitbox_triggered(body: Node3D, hitbox: Hitbox) -> void:
	hitbox_triggered.emit(body, hitbox)

func activate() -> void:
	if is_active == false:
		# FramePrint.prt("ACTIVATING %s.%s" % [get_parent().name, name])
		is_active = true
		for child: Hitbox in self.get_children():
			child.is_active = true

func deactivate() -> void:
	if is_active == true:
		# FramePrint.prt("DEACTIVATING %s.%s" % [get_parent().name, name])
		is_active = false
		for child: Hitbox in self.get_children():
			child.is_active = false
			child.sent_trigger_this_activation = false