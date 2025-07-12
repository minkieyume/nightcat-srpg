extends Phase

var return_ = false

func _ready() -> void:
	super()
	add_event_handler("return",_return)

func _enter() -> void:
	super()
	CommandBus.cat_send_command("menu",["setcargo","part",context["part"]])
	CommandBus.cat_send_command("menu",["setcargo","mode","chose_action"])
	CommandBus.cat_send_command("menu",["setcargo","actor",context["actor"]])
	CommandBus.cat_send_command("menu",["setcargo","mode","chose_action"])
	CommandBus.cat_send_command("menu",["chose_action"])

func _exit() -> void:
	if return_:
		return_ = false
		context["mode"] = "chose_character"
	else:
		context["mode"] = "action_precheck"
	super()
	

func _return() -> bool:
	return_ = true
	dispatch("back")
	return true
