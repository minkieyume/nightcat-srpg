extends Phase

func _exit() -> void:
	var cats = LevelHandler.get_units().filter(func(u):return LevelHandler.is_unit_in_group(u.id,"cat_feet"))
	for cat in cats:
		cat.cat_feet = false
	call_deferred("dispatch","next")
