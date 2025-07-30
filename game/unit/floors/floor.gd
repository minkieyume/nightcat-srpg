extends Unit

@onready var normal_state = $AnimationMachine/Normal
@onready var smooth_state = $AnimationMachine/Smooth

func _init_animation_machine() -> void:
	animation_machine.add_transition(normal_state,smooth_state,"switch")
	animation_machine.add_transition(smooth_state,normal_state,"switch")
	animation_machine.initialize(self)
	animation_machine.set_active(true)

@rpc("authority","call_local")
func interact(_character:String,_ctx:Dictionary):
	animation_machine.dispatch("switch")

@rpc("authority","call_local")
func unit_enter(_unit:Unit):
	pass

@rpc("authority","call_local")
func unit_exit(_unit:Unit):
	pass
