extends Phase

func _enter() -> void:
	super()
	context.erase("actor")
	CommandBus.cat_send_command("menu",["setcargo","part","player"])
	CommandBus.cat_send_command("menu",["setcargo","mode","chose_character"])
	CommandBus.cat_send_command("menu",["chose_target"])
	#print("character")
	#print(get_parent().get_active_state())
