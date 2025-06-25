extends Phase

func _enter() -> void:
	context["master"] = "enemy"
	call_deferred("dispatch","next")
