extends Phase

func _enter() -> void:
	super()
	var unit:Unit = context["actor"]
	if unit.is_in_group("ai"):
		await unit.ai.end_action()
		unit.update_sight_view()
	LevelHandler.get_grid_drawer().update()
	call_deferred("dispatch","next")
