extends Phase

func _enter() -> void:
	if MultiCat.should_sync():
		if is_multiplayer_authority():
			call_deferred("dispatch","authority")
	else:
		call_deferred("dispatch","authority")
