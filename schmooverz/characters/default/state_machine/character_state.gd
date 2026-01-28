@abstract
class_name CharacterState
extends BaseEntityState

@export var flush_inputs_on_enter: bool = false

@export_group("Parameters")
#@export var physics_parameters: CharacterPhysics = CharacterPhysics.new()
@export var gameplay_action: GameplayAction = null
# @export var camera_parameters: CameraParameters = CameraParameters.new()

var input_converter: InputConverter = null

func _ready() -> void:
	character = owner as CharacterInstance

func enter(_msg := {}) -> void:
	super()
	if flush_inputs_on_enter:
		gameplay_action.flush_buffer_for_actions()

func input(_event: InputEvent) -> void:
	super(_event)

func unhandled_input(_event: InputEvent) -> void:
	super(_event)

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

		var h_direction: Vector3 = Vector3(input_converter.stick_position.x, 0, 0)
		match physics_type:
			PhysicsType.GROUNDED_ALL:
				if input_converter.stick_position.x == 0.0:
					move_x_toward_by_frame(Vector3.ZERO, character.physics_parameters.GROUND_FRICTION)
				else:
					move_x_toward_by_frame(h_direction * character.physics_parameters.MAX_RUN_SPEED, character.physics_parameters.GROUND_FRICTION)
			PhysicsType.GROUNDED_ONLY_FRICTION:
				move_x_toward_by_frame(Vector3.ZERO, character.physics_parameters.GROUND_FRICTION)
			PhysicsType.AERIAL_ALL:
				if input_converter.stick_position.x == 0.0:
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

func exit() -> void:
	super()

func on_frame_count_reached() -> void:
	super()
