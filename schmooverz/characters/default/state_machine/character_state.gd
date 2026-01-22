@abstract
class_name CharacterState
extends State

var character: CharacterInstance

@export var default_physics: bool = true
@export var apply_gravity: bool = true
@export var handle_movements_input: bool = true
@export var should_play_animation_on_enter: bool = true
@export var flush_inputs_on_enter: bool = false
@export var has_set_frame_duration: bool = false
@export var set_frame_duration: int = 0

@export_group("Parameters")
#@export var physics_parameters: CharacterPhysics = CharacterPhysics.new()
@export var gameplay_action: GameplayAction = null
# @export var camera_parameters: CameraParameters = CameraParameters.new()

@onready var saved_max_speed: float = 0

var input_converter: InputConverter = null

func _ready() -> void:
	character = owner as CharacterInstance
	saved_max_speed = character.physics_parameters.MAX_SPEED

var frame_count: int = 0
var first_actionable_frame: int = 0

func enter(_msg := {}) -> void:
	if should_play_animation_on_enter:
		play_animation()
	if flush_inputs_on_enter:
		gameplay_action.flush_buffer_for_actions()
	frame_count = 0


func input(_event: InputEvent) -> void:
	pass

func unhandled_input(_event: InputEvent) -> void:
	pass

func physics_update(_delta: float, move_character: bool = true) -> void:
	
	if default_physics:
		## Extracting vertical velocity
		var y_velocity: float = character.velocity.y
		character.velocity.y = 0.0

		## Horizontal Movement.
		## If we have no movement, stop using acceleration and use friction instead.
		## The more acceleration we have, the faster we accelerate.
		## The more friction we have, the faster we decelerate.
		# if handle_movements_input:
		# 	if input_converter.stick_position.x == 0.0:
		# 		character.velocity = character.velocity.move_toward(character.direction * character.physics_parameters.MAX_SPEED, character.physics_parameters.FRICTION * _delta)
		# 	else:
		# 		character.velocity = character.velocity.move_toward(character.direction * character.physics_parameters.MAX_SPEED, character.physics_parameters.ACCELERATION * _delta)

		## Incorporating vertical velocity back into the mix.
		character.velocity.y = y_velocity

		if apply_gravity:
			character.velocity.y += character.physics_parameters.GRAVITY * _delta

		if move_character:
			character.move_and_slide()
	# if character.debug_canvas:
	# 	character.debug_canvas.set_speedometer(character.velocity)
	# 	character.debug_canvas.set_world_position(character.position)
	## Reseting raw input
	character.raw_input = 0.0
	frame_count += 1
	if frame_count == set_frame_duration:
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
