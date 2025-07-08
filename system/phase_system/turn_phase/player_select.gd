extends Phase

func _enter() -> void:
	super()
	CommandBus.send_command("menu",["setcargo","part","player"])
	CommandBus.send_command("menu",["setcargo","mode","chose_character"])
	CommandBus.send_command("menu",["action"])

func _exit() -> void:
	context["mode"] = "before_action"
	super()
	
