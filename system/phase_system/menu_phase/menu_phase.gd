class_name MenuPhase
extends Phase

func _ready() -> void:
	super()
	add_event_handler("return",_return)

func _return(cargo:Dictionary) -> bool:
	return true
