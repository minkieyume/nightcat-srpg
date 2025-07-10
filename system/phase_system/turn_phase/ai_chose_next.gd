extends Phase

func _enter() -> void:
	super()
	context["mode"] = "ai_chose_character"
	var units:Array = context["units"]
	if !units.is_empty():
		var unit = units.pop_front()
		context["actor"] = unit
		var camera = LevelHandler.get_camera()
		camera.set_follow_target(unit)
		call_deferred("dispatch","next")
	else:
		context.erase("units")
		context.erase("actor")
		call_deferred("dispatch","end")
