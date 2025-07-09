extends ActionLogic

func before_target_chose(action:Action):
	var quester = LevelHandler.get_grid_quester()
	var move_server = LevelHandler.get_movement_server()

	# 更新行动范围配置
	var deter_array = action.clac_action_range()
	var pos = LevelHandler.get_unit_position(action.requester)
	var ap = LevelHandler.get_character(action.requester).get_ap()
	deter_array = deter_array.filter(func(x):return \
		move_server.is_point_reachable(action.requester,x))
	deter_array = deter_array.filter(func(x):return move_server.get_path_length(pos,x)<=ap)
	var new_range = ActionRange.new()
	new_range.deter_array = deter_array
	new_range.type = 0
	action.set_action_range(new_range)

func precheck(action:Action) -> bool:
	var agent:Character = LevelHandler.get_character(action.requester)
	var start = LevelHandler.get_unit_position(action.requester)	
	var server = LevelHandler.get_movement_server()	
	if server.is_point_reachable(action.requester,action.target):
		var ap_cost = server.get_path_length(start, action.target)
		action.set_ap_cost(ap_cost)
		if agent.get_ap() >= ap_cost:
			return true
	return false

func execute(action:Action):
	var character = action.requester
	var target = action.target
	var server = LevelHandler.get_movement_server()
	await server.move_unit(character,target)

#func execute(character:Character,grid_map:TileMapLayer,\
#	target:Vector2i) -> bool:
#	character.request_move_to(target)
#	return true
