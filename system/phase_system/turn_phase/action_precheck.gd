extends Phase

func _enter():
	super()
	match context["mode"]:
		"action_precheck":
			var camera = LevelHandler.get_camera()			
			camera.set_follow_target(LevelHandler.get_character(context["actor"]))			
			var action = Action.from_dict(context["action"])
			action.set_ctx(context)
			await action.before_precheck()
			var presult = await action.precheck()
			context["action"] = action.to_dictionary()
			action.free()
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
			clean_action()			
	
func clean_action():	
	context.erase("target")
	context.erase("action")
