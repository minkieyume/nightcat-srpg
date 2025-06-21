extends ActionLogic

# 正义跳跃：跳跃1格，越小障碍
func execute(character:String, target:Vector2i, handler:LevelHandler) -> bool:
	var grid_map = handler.get_grid_map()
	var actor = handler.get_character(character)
	var from = handler.get_character_position(character)
	var dir = target - from
	if dir.length() == 1 and grid_map.is_cell_cover_low(target):
		# 跳跃到目标格
		handler.send_command("move_character", [character, target])
		await actor.path_end
		return true
	return false
