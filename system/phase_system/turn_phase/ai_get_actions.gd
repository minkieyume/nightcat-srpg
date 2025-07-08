extends Phase

func _enter() -> void:
	super()
	var unit:Unit = context["actor"]
	if unit.is_in_group("ai"):
		context["actions"] = await unit.ai.get_next_action()
		call_deferred("dispatch","next")
	call_deferred("dispatch","failed")
