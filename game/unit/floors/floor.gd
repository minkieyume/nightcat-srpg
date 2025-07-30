extends Unit

@onready var normal_state = $AnimationMachine/Normal
@onready var smooth_state = $AnimationMachine/Smooth

func _init_animation_machine() -> void:
	animation_machine.add_transition(normal_state,smooth_state,"smooth")
	animation_machine.add_transition(smooth_state,normal_state,"normal")
	animation_machine.initialize(self)
	animation_machine.set_active(true)

@rpc("authority","call_local")
func unit_enter(unit:Unit):
	pass

@rpc("authority","call_local")
func unit_exit(unit:Unit):
	pass
