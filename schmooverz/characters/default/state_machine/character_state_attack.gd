extends CharacterStateFrames
class_name CharacterStateAttack

## HitWindow name must be always even. `HitWindow0` then `HitWindow2` then `HitWindow4`...
@export var window_naming_convention: String = "HitWindow%d"
@export var x_displacement_by_frame: float = 0
@onready var hitboxes_windows: Array[HitboxGroup] = []

func _ready() -> void:
	register_all_windows()
	deactivate_all_hitbox_windows()
	super()

func register_all_windows() -> void:
	for child in get_children():
		if child is HitboxGroup:
			hitboxes_windows.append(child)
			child.hitbox_triggered.connect(on_hitbox_triggered)

func deactivate_all_hitbox_windows() -> void:
	for window: HitboxGroup in hitboxes_windows:
		window.deactivate()

func activate_window(window_number: int) -> void:
	var window: HitboxGroup = find_window_by_number(window_number)
	if window:
		window.activate()

func deactivate_window(window_number: int) -> void:
	var window: HitboxGroup = find_window_by_number(window_number)
	if window:
		window.deactivate()

func find_window_by_number(window_number: int) -> HitboxGroup:
	for area: HitboxGroup in hitboxes_windows:
		if area.name == window_naming_convention % window_number:
			return area
	return null

func during_active_frame(_index: int) -> void:
	activate_window(_index)

func during_inactive_frame(_index: int) -> void:
	deactivate_window(_index - 1)

func during_endlag() -> void:
	deactivate_all_hitbox_windows()

func exit():
	super()
	deactivate_all_hitbox_windows()

func physics_update(_delta, _move_character: bool = true):
	if x_displacement_by_frame != 0:
		character.velocity.x = x_displacement_by_frame * (1.0 if character.facing_direction else -1.0)
	super(_delta)

func should_flip_hit(body: Node3D) -> bool:
	return body.global_position.x < self.global_position.x

func on_hitbox_triggered(body: Node3D, hitbox: Hitbox) -> void:
	if hitbox.hitbox_type == hitbox.HitboxType.CLASSIC:
		if body.has_method("hit"):
			body.hit(hitbox, should_flip_hit(body))
		state_machine.add_hitpause(hitbox.self_hitpause)
		FramePrint.prt("Hit %s with %s" % [body, hitbox])
