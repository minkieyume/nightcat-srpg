extends Phase

var first_run = true

func _enter() -> void:	
	if !first_run:
		CommandBus.send_command("gamephase",["menu_hide"])
	first_run = false
