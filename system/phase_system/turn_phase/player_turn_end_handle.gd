extends Phase

func _enter() -> void:	
	CommandBus.cat_send_command("menu",["hide"])
	call_deferred("dispatch","next")
