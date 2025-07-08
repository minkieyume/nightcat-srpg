extends Phase

var first_run = true

func _enter() -> void:	
	if !first_run:
		CommandBus.send_command("gamephase",["next"])
	first_run = false
