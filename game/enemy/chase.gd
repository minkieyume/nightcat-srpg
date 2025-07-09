extends StateAIState

func before_action():
	agent.update_sight_units()
	# var sc:Array = agent.in_sight_characters
	# if sc.is_empty():
	# 	dispatch("lost_enemy")

func get_next_action():
	var quester = LevelHandler.get_grid_quester()
	var movement = LevelHandler.get_movement_server()
	var ap = agent.get_ap()
	if ap <= 0:
		return null

	var nearby_tiles = quester.quest_tiles_nearby_unit(agent.id)
	var nearby_player = quester.quest_character_in_area(nearby_tiles).\
		filter(func(c):return LevelHandler.is_unit_in_group(c.id,"player"))
	print(nearby_player)
	if nearby_player.is_empty():
		var move_action = await get_move_near_character_action()
		if move_action != null:			
			var result = await move_action.precheck()
			if result:
				return move_action	
	return null

	
	#var ap_cost = move_action.get_ap_coast()
	#ap = ap - ap_cost
	#if ap <= 0:
	#	return action_array

	# # 随机选取一个带有攻击标签的action，以后可以做成一个通用方法。
	# # 也就是让敌人随机选取任意一个符合条件的行动，并根据剩余ap决定执行哪个行动的方法。
	# var action_manager:ActionManager = agent.action_manager
	# var attack_actions = action_manager.get_action_id_list(\
	# 	func(a:ActionResource):return a.has_tag("attack"))
	# if attack_actions.size() > 0:
	# 	while ap > 0:
	# 		var rand_acton_index = randi()%(attack_actions.size()-1)			
	# 		var action = attack_actions[rand_acton_index]
	# 		var action_ap  = action_manager.get_action_resouce(action).ap_cost
	# 		if ap >= action_ap:
	# 			Action.new(agent.id,action)
	# 			await action.before_target_chose()
	#			
	#return action_array

## 获取移动到角色附近的动作
func get_move_near_character_action():
	var grid_quester = LevelHandler.get_grid_quester()
	var server = LevelHandler.get_movement_server()
	var origin = LevelHandler.get_unit_position(agent.id)

	var action = Action.new(agent.id,&"move")
	await action.before_target_chose()

	# 获取距离自身最近的玩家的最近临近格
	var chase_radius = grid_quester.quest_tiles_in_radius(origin,agent.chase_radius)
	var characters = grid_quester.quest_character_in_area(chase_radius).filter(func(c):return LevelHandler.is_unit_in_group(c.id,"player"))
	var nearst_target = null
	for character in characters:
		var near_target = grid_quester.quest_tiles_nearby_unit(character.id)\
			.filter(func(p):return server.is_point_reachable(agent.id,p))\
				.reduce(_get_near_pos)		
		if near_target != null:
			if nearst_target == null:
				nearst_target = near_target
			else:
				nearst_target = _get_near_pos(near_target,nearst_target)	

	if nearst_target == null:
		return null
	# 获取行动的限制范围，并选择限制范围中最接近该玩家的最近临近格的格子。
	var limit_array = action.clac_action_range()
	var target = nearst_target
	for target_pos in limit_array:
		if server.is_point_reachable(agent.id,target_pos):
			if target == null:
				target = target_pos
			elif target.distance_to(nearst_target) > target_pos.distance_to(nearst_target):
				target = target_pos
	
	if target != null:
		action.set_target(target)	
		return action
	else:
		return null

func _get_near_pos(c1:Vector2i,c2:Vector2i):
	var origin:Vector2i = LevelHandler.get_unit_position(agent.id)
	if origin.distance_to(c1) < origin.distance_to(c2):
		return c1
	else:
		return c2
