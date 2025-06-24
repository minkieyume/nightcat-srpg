extends ActionLogic

func execute(character:String, target:Vector2i, handler:LevelHandler) -> bool:
	var agent = handler.get_character(character)
	var grid_map = handler.get_grid_map()
	var start = grid_map.local_to_map(agent.position)
	# OOP式调用LevelHandler的get_path_length
	var ap_cost = handler.get_path_length(start, target)
	# 强制ap_cost最大不能超过当前AP
	var cur_ap = agent.get_ap()
	if ap_cost > cur_ap:
		ap_cost = cur_ap
	# 动态设置本次ActionResource的ap_cost
	var am = agent.action_manager
	if am:
		var action_res = am.get_action_resouce(&"move")
		if action_res:
			action_res.ap_cost = ap_cost
	# 发送移动命令
	handler.send_command("move_character", [character, target])	
	await agent.path_end
	return true

#func execute(character:Character,grid_map:TileMapLayer,\
#	target:Vector2i) -> bool:
#	character.request_move_to(target)
#	return true
