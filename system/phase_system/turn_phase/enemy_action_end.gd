extends Phase

func _enter() -> void:
	super()
	var unit:Unit = LevelHandler.get_unit(context["actor"])
	if unit.is_in_group("ai"):
		await unit.ai.end_action()
		unit.update_sight_view()	
	call_deferred("dispatch","next")
