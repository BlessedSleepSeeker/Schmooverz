extends BaseEntityState

var hitstun_duration: int = 0

func enter(_msg = {}):
	super()
	self.set_frame_duration = _msg.get("hitpause_duration", 0)
	self.has_set_frame_duration = true
	self.hitstun_duration = _msg.get("hitstun_duration", 0)
	#wiggly anim here

func unhandled_input(_event: InputEvent):
	super(_event)

func physics_update(_delta, _move_character: bool = true):
	super(_delta)

func exit():
	self.has_set_frame_duration = false
	self.set_frame_duration = -1
	super()

func on_frame_count_reached():
	state_machine.transition_to("Hitstun", {"hitstun_duration": hitstun_duration})

func _notification(_what):
	pass
