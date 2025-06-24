extends ActionLogic

# 蜡笔爆冲：冲刺2格，击飞晕眩1敌
func execute(character:String, target:Vector2i, handler:LevelHandler) -> bool:
	var grid_map = handler.get_grid_map()
	var actor = handler.get_character(character)
	var from = handler.get_character_position(character)
	var dir = target - from
	if dir.length() == 2 and grid_map.is_cell_passable(target):
		handler.send_command("move_character", [character, target])
		await actor.path_end
		# 检查目标格是否有敌人
		var enemies = handler.get_enemy_list()
		for enemy in enemies:
			if handler.get_character_position(enemy.get_instance_id()) == target:
				enemy.set_state("stun", 1)
				enemy.knockback(dir)
				break
		return true
	return false
