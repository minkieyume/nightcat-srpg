extends Phase

func _enter() -> void:
	super()
	context["mode"] = "ai_chose_action"	
	var unit:Unit = context["actor"]
	if unit.is_in_group("ai"):
		var action = await unit.ai.get_next_action()		
		if action != null:
			context["mode"] = "start_action"
			context["action"] = action
			call_deferred("dispatch","next")
			call_deferred("next_action",action)
			return
	context.erase("actor")
	call_deferred("dispatch","end")	
