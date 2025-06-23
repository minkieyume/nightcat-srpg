extends Phase

func _enter() -> void:
	print("[RestoreAP] 进入阶段 - 恢复所有角色AP")
	
	# 遍历所有角色并恢复AP到最大值
	var characters = level_handler.get_character_array()
	for character in characters:
		if character.has_method("reset_ap"):
			var old_ap = character.get_ap()
			character.reset_ap()
			var new_ap = character.get_ap()
	
	# 短暂等待后自动转换到下一阶段
	await get_tree().create_timer(0.5).timeout
	
	# 转换到CooldownTick阶段
	dispatch("turn_end")
	var cooldown_tick = get_parent().get_node("CooldownTick")
	if cooldown_tick:
		transition["next"] = cooldown_tick
		dispatch("next")

func _ready() -> void:
	# 在ready时配置转换
	var cooldown_tick = get_parent().get_node("CooldownTick")
	if cooldown_tick:
		transition["next"] = cooldown_tick
