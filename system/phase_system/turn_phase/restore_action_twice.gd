extends Phase

func _enter() -> void:
	super()
	print("[Restore] 恢复所有角色行动计次")
	var characters = LevelHandler.get_characters()
	for character in characters:
		if character.has_method("reset_action_twice"):
			if MultiCat.is_online():
				if is_multiplayer_authority():
					character.rpc("reset_action_twice")
			character.reset_action_twice()
	call_deferred("dispatch","next")
