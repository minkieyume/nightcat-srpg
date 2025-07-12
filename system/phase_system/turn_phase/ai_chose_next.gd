extends Phase

func _enter() -> void:
	super()
	context["mode"] = "ai_chose_character"
	var units:Array = context["units"]
	if !units.is_empty():
		var unit = units.pop_front()
		context["actor"] = unit
		LevelHandler.cat_set_camera_folllow_unit(unit)
		call_deferred("dispatch","next")
	else:
		context.erase("units")
		context.erase("actor")
		call_deferred("dispatch","end")
