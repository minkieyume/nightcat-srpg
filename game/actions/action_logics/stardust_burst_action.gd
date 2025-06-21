extends ActionLogic

# 星屑纷飞：半径2格内敌人呆滞或随机移动
func execute(character:int, target:Vector2i, handler:LevelHandler) -> bool:
	var grid_map = handler.get_grid_map()
	var center = handler.get_character_position(character)
	var area = grid_map.get_cells_in_radius(center, 2)
	var enemies = handler.get_enemy_list()
	for enemy in enemies:
		var pos = handler.get_character_position(enemy.get_instance_id())
		if pos in area:
			if randi() % 2 == 0:
				enemy.set_state("daze", 1)
			else:
				enemy.random_move()
	return true
