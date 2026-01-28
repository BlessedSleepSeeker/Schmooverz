@abstract
class_name BaseEntityState
extends State

var character: BasePlatfighterEntity

enum PhysicsType {
	GROUNDED_ALL,
	GROUNDED_ONLY_FRICTION,
	AERIAL_ALL,
	AERIAL_ONLY_FRICTION,
	SPECIAL
}

@export var default_physics: bool = true
@export var apply_gravity: bool = true
@export var physics_type: PhysicsType = PhysicsType.GROUNDED_ALL

@export var should_play_animation_on_enter: bool = true
@export var has_set_frame_duration: bool = false
@export var set_frame_duration: int = 0

var frame_count: int = 0
var first_actionable_frame: int = 0

var control_interface: ControlInterface

func _ready() -> void:
	character = owner as BasePlatfighterEntity

func enter(_msg := {}) -> void:
	if should_play_animation_on_enter:
		play_animation()
	frame_count = 0

func input(_event: InputEvent) -> void:
	pass

func unhandled_input(_event: InputEvent) -> void:
	pass

func move_x_toward_by_frame(movement_direction: Vector3, step: float) -> void:
	if character.velocity.x == movement_direction.x:
		return
	var _direction: bool = character.velocity.x < movement_direction.x
	if _direction:
		character.velocity.x += step
		if character.velocity.x > movement_direction.x:
			character.velocity.x = movement_direction.x
	else:
		character.velocity.x -= step
		if character.velocity.x < movement_direction.x:
			character.velocity.x = movement_direction.x

func move_y_toward_by_frame(movement_direction: Vector3, step: float) -> void:
	if character.velocity.y == movement_direction.y:
		return
	var _direction: bool = character.velocity.y < movement_direction.y
	if _direction:
		character.velocity.y += step
		if character.velocity.y > movement_direction.y:
			character.velocity.y = movement_direction.y
	else:
		character.velocity.y -= step
		if character.velocity.y < movement_direction.y:
			character.velocity.y = movement_direction.y

func flip_hitboxes(direction: bool) -> void:
	if direction:
		self.rotation_degrees.y = 0
	else:
		self.rotation_degrees.y = 180

func physics_update(_delta: float, move_character: bool = true) -> void:
	#var test: Vector3 = Vector3(10, 10, 10)
	#print(test.move_toward(Vector3.ZERO, 0.5))
	if default_physics:
		## Extracting vertical velocity
		var y_velocity: float = character.velocity.y
		character.velocity.y = 0.0

		## Horizontal Movement.
		## If we have no movement, stop using acceleration and use friction instead.
		## The more acceleration we have, the faster we accelerate.
		## The more friction we have, the faster we decelerate.

		var h_direction: Vector3 = Vector3(control_interface.stick_position.x, 0, 0)
		match physics_type:
			PhysicsType.GROUNDED_ALL:
				if control_interface.stick_position.x == 0.0:
					move_x_toward_by_frame(Vector3.ZERO, character.physics_parameters.GROUND_FRICTION)
				else:
					move_x_toward_by_frame(h_direction * character.physics_parameters.MAX_RUN_SPEED, character.physics_parameters.GROUND_FRICTION)
			PhysicsType.GROUNDED_ONLY_FRICTION:
				move_x_toward_by_frame(Vector3.ZERO, character.physics_parameters.GROUND_FRICTION)
			PhysicsType.AERIAL_ALL:
				if control_interface.stick_position.x == 0.0:
					move_x_toward_by_frame(Vector3.ZERO, character.physics_parameters.AIR_FRICTION)
				else:
					move_x_toward_by_frame(h_direction * character.physics_parameters.MAX_HORIZONTAL_AIR_SPEED, character.physics_parameters.AIR_ACCELERATION)
			PhysicsType.AERIAL_ONLY_FRICTION:
				move_x_toward_by_frame(Vector3.ZERO, character.physics_parameters.AIR_FRICTION)

		## Incorporating vertical velocity back into the mix.
		character.velocity.y = y_velocity

		if apply_gravity:
			character.velocity.y -= character.physics_parameters.GRAVITY
			if character.physics_parameters.is_fastfalling:
				character.velocity.y = clampf(-character.physics_parameters.FAST_FALL_SPEED, -character.physics_parameters.FAST_FALL_SPEED, 10000)
			else:
				character.velocity.y = clampf(character.velocity.y, -character.physics_parameters.MAX_FALL_SPEED, 10000)

		if move_character:
			character.move_and_slide()
	frame_count += 1
	if frame_count == set_frame_duration && has_set_frame_duration:
		on_frame_count_reached()

func can_act_out_of_state() -> bool:
	return frame_count >= first_actionable_frame

func exit() -> void:
	pass

func play_animation(_anim_name: String = "") -> void:
	if _anim_name:
		character.play_animation(_anim_name)
	else:
		character.play_animation(self.name)

func on_frame_count_reached() -> void:
	pass
