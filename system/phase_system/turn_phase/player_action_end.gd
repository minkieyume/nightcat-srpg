extends Phase

func _enter() -> void:
	super()
	call_deferred("dispatch","next")
