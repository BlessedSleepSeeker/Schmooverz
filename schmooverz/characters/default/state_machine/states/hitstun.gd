extends BaseEntityState

var character_velocity: Vector3 = Vector3.ZERO

func enter(_msg = {}):
	super()
	character_velocity = Vector3.ZERO
	self.set_frame_duration = _msg.get("hitstun_duration", 0)
	has_set_frame_duration = true

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	character.velocity = character.knockback_velocity + character_velocity
	super(_delta)
	character_velocity.y -= character.physics_parameters.HITSTUN_GRAVITY
	character_velocity.y = clampf(character_velocity.y, -character.physics_parameters.MAX_FALL_SPEED, 0)
	character.knockback_velocity.y -= character.physics_parameters.KNOCKBACK_SPEED_DECREASE
	if character.knockback_velocity.x > 0:
		character.knockback_velocity.x -= character.physics_parameters.KNOCKBACK_SPEED_DECREASE
	else:
		character.knockback_velocity.x += character.physics_parameters.KNOCKBACK_SPEED_DECREASE
	character.move_and_slide()

func exit():
	self.has_set_frame_duration = false
	self.set_frame_duration = -1
	character.knockback_velocity = Vector3.ZERO

func on_frame_count_reached():
	state_machine.transition_to("Tumble")

func _notification(_what):
	pass
