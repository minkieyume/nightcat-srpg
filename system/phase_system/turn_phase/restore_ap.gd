extends Phase

func _enter() -> void:
	super()
	print("[RestoreAP] 进入阶段 - 恢复所有角色AP")
	# 遍历所有角色并恢复AP到最大值
	var characters = LevelHandler.get_characters()
	for character in characters:
		if character.has_method("reset_ap"):
			if MultiCat.is_online():
				if is_multiplayer_authority():
					character.rpc("reset_ap")
			character.reset_ap()
	
	# 短暂等待后自动转换到下一阶段
	await get_tree().create_timer(0.5).timeout
	dispatch("next")
