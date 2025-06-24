extends Phase

func _enter() -> void:
	call_deferred("dispatch", "turn_end")
