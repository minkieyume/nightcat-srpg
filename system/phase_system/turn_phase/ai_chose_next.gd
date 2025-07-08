extends Phase

func _enter() -> void:
	super()
	var units:Array = context["units"]
	if !units.is_empty():
		var unit = units.pop_front()
		context["actor"] = unit
		call_deferred("dispatch","next")
	else:
		context.erase("units")
		call_deferred("dispatch","end")
