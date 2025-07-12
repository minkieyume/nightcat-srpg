extends Phase

func _enter() -> void:
	super()
	context["mode"] = "ai_chose_action"	
	var unit:Unit = LevelHandler.get_unit(context["actor"])
	if unit.is_in_group("ai"):
		await unit.ai.before_action()
		var action:Action = await unit.ai.get_next_action()
		if action != null:
			context["mode"] = "start_action"
			context["action"] = action.to_dictionary()
			call_deferred("dispatch","next")
			return
	context.erase("actor")
	call_deferred("dispatch","end")	
