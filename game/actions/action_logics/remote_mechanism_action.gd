extends ActionLogic

# 机关遥控：远控5格机关，支持扩展模式
func execute(character:int, target:Vector2i, handler:LevelHandler) -> bool:
	var from = handler.get_character_position(character)
	if from.distance_to(target) > 5:
		return false
	var grid_map = handler.get_grid_map()
	if grid_map.is_cell_mechanism(target):
		# 触发机关逻辑
		var mechanism = handler.get_mechanism_at(target)
		if mechanism:
			mechanism.trigger()
			return true
	return false
