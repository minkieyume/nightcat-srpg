extends ActionLogic

# 夜猫挑战：引发半径3格敌人连锁反应，视目击等级变化
func execute(character:int, target:Vector2i, handler:LevelHandler) -> bool:
	var grid_map = handler.get_grid_map()
	var enemies = handler.get_enemy_list()
	var center = handler.get_character_position(character)
	var affected = grid_map.get_cells_in_radius(center, 3)
	for enemy in enemies:
		var pos = handler.get_character_position(enemy.get_instance_id())
		if pos in affected:
			# 目击等级判定（伪代码，需结合实际视野/遮挡实现）
			var sight = enemy.calc_sight_level(center, grid_map)
			if sight == "clear":
				enemy.set_state("chase", 1)
			elif sight == "suspicious":
				enemy.set_state("suspicious", 1)
			else:
				enemy.set_state("curious", 1)
			# 触发小动作演出（可选）
			enemy.play_react_animation()
	return true
