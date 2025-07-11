class_name MenuPhase
extends Phase

func _ready() -> void:
	super()
	add_event_handler("return",_return)

func _exit() -> void:
	send_cargo(context)

func _return() -> bool:
	return true
