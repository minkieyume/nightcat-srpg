extends Interactable

@onready var open_state = $AnimationMachine/Open
@onready var close_state = $AnimationMachine/Close

func _init_animation_machine() -> void:
	animation_machine.add_transition(open_state,close_state,"close")
	animation_machine.add_transition(close_state,open_state,"open")
	animation_machine.initialize(self)
	animation_machine.set_active(true)

@rpc("authority","call_local")
func interact(_character:String,ctx:Dictionary):
	pass
