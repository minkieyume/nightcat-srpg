extends Phase

func _enter() -> void:
	super()
	context.erase("actor")
	CommandBus.send_command("menu",["setcargo","part","player"])
	CommandBus.send_command("menu",["setcargo","mode","chose_character"])
	CommandBus.send_command("menu",["chose_target"])
	print("phase")
	#print("character")
	#print(get_parent().get_active_state())
