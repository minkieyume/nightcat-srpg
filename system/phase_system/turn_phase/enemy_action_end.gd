extends Phase

func _enter() -> void:
	super()
	var unit:Unit = context["actor"]
	if unit.is_in_group("ai"):
		await unit.ai.end_action()
	call_deferred("dispatch","next")
