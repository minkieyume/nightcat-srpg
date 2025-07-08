extends Phase

func _enter() -> void:
	super()
	var unit:Unit = context["actor"]
	if unit.is_in_group("ai"):
		var action = await unit.ai.get_next_action()
		if action != null:
			context["action"] = action
			call_deferred("dispatch","next")
			return
	context.erase("actor")
	call_deferred("dispatch","end")
