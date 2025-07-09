extends Phase

func _enter():
	super()
	clean_action()
	call_deferred("dispatch","next")

func clean_action():
	var action = context["action"]
	context.erase("actor")
	context.erase("target")
	context.erase("action")
	context["mode"] = "action_failed"
	action.call_deferred("free")
