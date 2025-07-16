extends Phase

func _enter() -> void:
	super()
	print("移除失效buff")
	# 移除失效buff
	var characters = LevelHandler.get_characters()
	for character in characters:
		if character.has_method("clean_buff"):
			if MultiCat.is_online():
				if is_multiplayer_authority():
					character.rpc("clean_buff")
			character.clean_buff()
	call_deferred("dispatch","next")
