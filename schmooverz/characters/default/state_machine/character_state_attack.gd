extends CharacterStateFrames
class_name CharacterStateAttack

## HitWindow name must be always even. `HitWindow0` then `HitWindow2` then `HitWindow4`...
@export var window_naming_convention: String = "HitWindow%d"
@onready var hitboxes_windows: Array[Area3D] = []

func _ready() -> void:
	register_all_windows()
	deactivate_all_hitbox_windows()
	super()

func register_all_windows() -> void:
	for child in get_children():
		if child is Area3D:
			hitboxes_windows.append(child)
			child.area_shape_entered.connect(hitbox_triggered)

func deactivate_all_hitbox_windows() -> void:
	for window: Area3D in hitboxes_windows:
		window.monitorable = false
		window.monitoring = false
		for child: Hitbox in window.get_children():
			child.set_deferred("disabled", true)
		#window.set_deferred("monitoring", false)
		#window.set_deferred("monitorable", false)

func activate_window(window_number: int) -> void:
	var window: Area3D = find_window_by_number(window_number)
	if window:
		window.monitoring = true
		window.monitorable = true
		for child: Hitbox in window.get_children():
			child.set_deferred("disabled", false)

func deactivate_window(window_number: int) -> void:
	var window: Area3D = find_window_by_number(window_number)
	window.monitoring = false
	window.monitorable = false
	for child: Hitbox in window.get_children():
			child.set_deferred("disabled", true)

func find_window_by_number(window_number: int) -> Area3D:
	for area: Area3D in hitboxes_windows:
		if area.name == window_naming_convention % window_number:
			return area
	return null

func hitbox_triggered(_area_rid: RID, _area: Area3D, area_shape_index: int, _local_shape_index: int) -> void:
	var other_shape_owner = _area.shape_find_owner(area_shape_index)
	var other_shape_node: Hitbox = _area.shape_owner_get_owner(other_shape_owner) as Hitbox

	FramePrint.prt(other_shape_node)

func on_overlaping_hitbox(hitbox: Area3D) -> void:
	pass

func during_active_frame(_index: int) -> void:
	activate_window(_index)
	var hitbox_area: Area3D = find_window_by_number(_index)
	if hitbox_area.has_overlapping_bodies() || hitbox_area.has_overlapping_areas():
		on_overlaping_hitbox(hitbox_area)

func during_inactive_frame(_index: int) -> void:
	deactivate_window(_index - 1)

func during_endlag() -> void:
	deactivate_all_hitbox_windows()