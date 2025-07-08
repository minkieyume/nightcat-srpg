extends ActionLogic

func before_target_chose(action:Action) -> bool:	
	var quester = LevelHandler.get_grid_quester()		

	# 更新行动范围配置
	var blocked_tiles = quester.quest_block_tiles()
	var deter_array = action.clac_action_range()
	deter_array = deter_array.filter(func(x):return not blocked_tiles.has(x))
	action.action_range.type = 0
	action.action_range.deter_array = deter_array
	return true

func before_run(action:Action) -> bool:	
	var agent = LevelHandler.get_character(action.requester)
	var grid_map = LevelHandler.get_grid_map()
	var start = grid_map.local_to_map(agent.position)
	var resource = action.resource
	# OOP式调用LevelLevelHandler的get_path_length
	var ap_cost = LevelHandler.get_path_length(start, action.target)

	# 设置行动的AP消费
	resource.ap_cost = ap_cost
	return true

func execute(action:Action) -> bool:
	var character = action.requester
	var target = action.target	
	var server = LevelHandler.get_movement_server()

	var result = await server.move_unit(character,target)
	return result

#func execute(character:Character,grid_map:TileMapLayer,\
#	target:Vector2i) -> bool:
#	character.request_move_to(target)
#	return true
