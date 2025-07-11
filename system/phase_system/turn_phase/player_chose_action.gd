extends Phase

func _enter() -> void:
	super()	
	CommandBus.send_command("menu",["setcargo","part","player"])
	CommandBus.send_command("menu",["setcargo","mode","chose_action"])
	CommandBus.send_command("menu",["setcargo","actor",context["actor"]])
	CommandBus.send_command("menu",["chose_action"])

func _exit() -> void:
	context["mode"] = "action_precheck"
	super()
	
