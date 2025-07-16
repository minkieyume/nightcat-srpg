extends Phase

func _enter() -> void:
	super()
	print("更新buff计数")
	# 更新buff计数
	var characters = LevelHandler.get_characters()
	for character in characters:
		if character.has_method("tick_buffs"):
			if MultiCat.is_online():
				if is_multiplayer_authority():
					character.rpc("tick_buffs")
			character.tick_buffs()	
	call_deferred("dispatch","next")
