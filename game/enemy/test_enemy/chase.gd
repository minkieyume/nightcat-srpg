extends AIPhase

func _enter() -> void:
	agent.expand_sight()
	agent.update_sight_view()
	super()	

func _exit() -> void:
	super()	
	agent.reset_sight()
	agent.update_sight_view()

func before_action():
	var qu:Array = agent.question_units
	agent.in_sight_units.append_array(qu)
	update_face_to_character()
	agent.update_sight_units()
	agent.clean_question_units()
	
	var sc:Array = agent.in_sight_units
	if sc.is_empty():
		dispatch("lost_enemy")

func update_face_to_character():
	var grid_quester = LevelHandler.get_grid_quester()
	var origin = LevelHandler.get_unit_position(agent.id)
	var c_pos = agent.in_sight_units.\
		filter(func(c):return LevelHandler.is_unit_in_group(c,"player")).\
		map(func(c):return LevelHandler.get_unit_position(c)).\
		reduce(_get_near_pos)
	if c_pos:
		var dir = grid_quester.quest_related_direction(origin,c_pos)
		agent.change_direction(dir)
		agent.update_sight_face(dir)
		agent.update_sight_view()

func get_next_action():
	var quester = LevelHandler.get_grid_quester()	
	var ap = agent.get_ap()
	if ap <= 0:
		return null

	var nearby_tiles = quester.quest_tiles_nearby_unit(agent.id)
	var nearby_player = quester.quest_character_in_area(nearby_tiles).\
		filter(func(c):return LevelHandler.is_unit_in_group(c.id,"player")).\
		filter(func(c):return c.id in agent.in_sight_units)
	if nearby_player.is_empty():
		var move_action = await get_move_near_character_action()
		if move_action != null:
			var result = await move_action.precheck()
			if result:
				return move_action
	else:
		if nearby_player.size() > 0:
			var rand_player_index = randi()%(nearby_player.size())
			var player = nearby_player[rand_player_index-1]
			var p_pos = LevelHandler.get_unit_position(player.id)
			return await random_attack(p_pos)
		else:
			return false

	
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

func random_attack(target:Vector2i):
	# 随机选取一个带有攻击标签的action，以后可以做成一个通用方法。
	# 也就是让敌人随机选取任意一个符合条件的行动，并根据剩余ap决定执行哪个行动的方法。
	var ap = agent.get_ap()	
	var action_manager:ActionManager = agent.action_manager
	var attack_actions = action_manager.get_action_id_list(\
		func(a:ActionResource):return a.has_tag("attack"))
	if attack_actions.size() > 0:
		var rand_acton_index = randi()%(attack_actions.size())
		var action_id = attack_actions[rand_acton_index-1]
		var action_ap  = action_manager.get_action_resouce(action_id).ap_cost
		if ap >= action_ap:
			var action = Action.new(agent.id,action_id)
			await action.before_target_chose()
			action.set_target(target)
			if await action.precheck():
				return action
	return null
	

## 获取移动到角色附近的动作
func get_move_near_character_action():
	var grid_quester = LevelHandler.get_grid_quester()
	var server = LevelHandler.get_movement_server()
	var origin = LevelHandler.get_unit_position(agent.id)

	var action = Action.new(agent.id,&"move")
	await action.before_target_chose()

	# 获取距离自身最近的玩家的最近临近格
	var sight_radius = grid_quester.quest_tiles_in_sight(origin,agent.sector)
	var characters = grid_quester.quest_character_in_area(sight_radius).\
		filter(func(c):return LevelHandler.is_unit_in_group(c.id,"player"))
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
	print(nearst_target)

	if nearst_target == null:
		return null
	
	# 获取行动的限制范围，并选择限制范围中最接近该玩家的最近临近格的格子。
	var limit_array = action.clac_action_range()
	var target = null
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
