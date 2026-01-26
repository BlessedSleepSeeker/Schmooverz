extends CharacterState

@export var max_shield_life: float = 50
@export var shield_decrease_per_tick: float = max_shield_life / (4 * 60)
@export var shield_regen_per_tick: float = max_shield_life / (6 * 60)

@export var current_shield_life: float = max_shield_life:
	set(value):
		current_shield_life = clampf(value, 0, max_shield_life)
		shield_life_updated.emit(current_shield_life, max_shield_life)
		if current_shield_life == 0:
			shield_broken.emit()

var shield_used: bool = false

signal shield_life_updated(value: float, max_value: float)
signal shield_broken

func _ready() -> void:
	super()
	shield_broken.connect(_on_shield_broken)

func enter(_msg = {}):
	shield_used = true
	character.skin.shield_vfx.toggle_shield_visibility(true)
	if _msg["PreviousState"] == "Dash":
		character.velocity.x = 0
	super()
	if not Input.is_action_pressed("shield"):
		state_machine.transition_to("ShieldRelease")

	if character.is_airborne():
		state_machine.transition_to("Fall")

func unhandled_input(_event: InputEvent):
	super(_event)
	if Input.is_action_just_released("shield"):
		state_machine.transition_to("ShieldRelease")
	if input_converter.can_trigger_action("jump"):
		state_machine.transition_to("JumpSquat")
	if input_converter.stick_position.y < 0:
		character.platdrop.emit()

func physics_update(_delta, _move_character: bool = true):
	super(_delta)
	if character.is_airborne():
		state_machine.transition_to("Fall")
	current_shield_life -= shield_decrease_per_tick

func _physics_process(_delta):
	if not shield_used:
		current_shield_life += shield_regen_per_tick

func exit():
	shield_used = false
	character.skin.shield_vfx.toggle_shield_visibility(false)

func on_frame_count_reached():
	pass

func _notification(_what):
	pass

func _on_shield_broken() -> void:
	state_machine.transition_to("ShieldBreak")
