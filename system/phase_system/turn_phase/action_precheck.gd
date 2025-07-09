extends Phase

func _enter():
	super()
	match context["mode"]:
		"action_precheck":
			var action = context["action"]
			action.set_ctx(context)
			await action.before_precheck()
			var presult = await action.precheck()
			if presult:
				context["mode"] = "start_action"				
				call_deferred("dispatch","next")
			else:
				print("行动预检查失败")
				context["mode"] = "end_action"
				call_deferred("dispatch","end")

func _exit():
	super()
	match context["mode"]:
		"end_action":
			call_deferred("clean_action")
	
func clean_action():
	var action = context["action"]
	context.erase("actor")
	context.erase("target")
	context.erase("action")
	action.free()
