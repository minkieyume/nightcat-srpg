extends Phase

func _enter():
	super()
	var iid = context["interactable"]
	var interactable = LevelHandler.get_unit(iid)
	if !interactable.is_in_group("interactable"):
		print("行动失败，不在组内")
		quit()
		call_deferred("failed")
	match context["mode"]:
		"before_interact":
			interactable.before_interact(context["actor"],context.duplicate())
		"interact":
			interactable.interact(context["actor"],context.duplicate())
		"end_interact":
			CommandBus.send_command("gamephase",["setcargo","mode","end_action"])
			call_deferred("dispatch","next")

func _exit():
	super()
	if context["mode"] == "end_interact":
		quit()

func quit():
	context.erase("actor")
	context.erase("interactable")
	context.erase("target")

# func _on_handler_command_send(command:StringName, args:Array) -> void:
# 	if command == "setcargo":
# 		if context.has("mode"):
# 			if context["mode"] == "befor_interact":
# 				context[args[0]] = context[args[1]]
# 	if command == "chose_target":
# 		#print(context)
# 		context["mode"] = "interact"
# 		context["target_chose_event"] = "interactable_target_chose"
# 		dispatch("chose_target")
