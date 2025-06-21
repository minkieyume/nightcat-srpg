extends ActionLogic

# 蜡笔封印阵：生成滑地3格，敌人滑行并混乱
func execute(character:int, target:Vector2i, handler:LevelHandler) -> bool:
	var grid_map = handler.get_grid_map()
	var from = handler.get_character_position(character)
	var dir = (target - from).sign()
	for i in range(1, 4):
		var pos = from + dir * i
		grid_map.set_cell_type(pos, grid_map.Terrain.SLIP)
		# 检查是否有敌人
		var enemies = handler.get_enemy_list()
		for enemy in enemies:
			if handler.get_character_position(enemy.get_instance_id()) == pos:
				enemy.set_state("confused", 1)
				enemy.slide_on_slip(dir)
	return true
