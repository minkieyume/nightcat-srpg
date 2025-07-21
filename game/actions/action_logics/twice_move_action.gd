extends ActionLogic

func before_target_chose(action:Action):	
	var move_server = LevelHandler.get_movement_server()

	# 更新行动范围配置
	var deter_array = action.clac_action_range()	
	deter_array = deter_array.filter(func(x):return \
		move_server.is_point_reachable(action.requester,x))
	var new_range = ActionRange.new()
	new_range.deter_array = deter_array
	new_range.type = 0
	action.set_action_range(new_range)

func precheck(action:Action) -> bool:
	var server = LevelHandler.get_movement_server()
	if server.is_point_reachable(action.requester,action.target):						
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
