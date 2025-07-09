extends Phase

func _setup() -> void:
	super()

func _enter() -> void:
	super()
	var parts:Array = context["parts"]
	if !parts.is_empty():
		context["part"] = parts.pop_front()
		call_deferred("dispatch","next")
	else:
		call_deferred("dispatch","end")
