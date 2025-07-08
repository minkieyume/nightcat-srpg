extends StateAIState

func before_action():
	agent.update_sight_character()
	#	var sc:Array = agent.in_sight_characters
	#	if sc.is_empty():
	#		dispatch("lost_enemy")

func get_next_action():
	var action_array = []
	var move_action = await get_move_near_character_action()
	action_array.append(move_action)
	return move_action

	#var ap = agent.get_ap()
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
func get_move_near_character_action() -> Action:
	var grid_quester = LevelHandler.get_grid_quester()	
	var origin = LevelHandler.get_unit_position(agent.id)
	var chase_radius = grid_quester.quest_tiles_in_radius(origin,agent.chase_radius)
	var characters = grid_quester.quest_character_in_area(chase_radius)
	var nearst = characters.reduce(_get_near_pos)
	var target = grid_quester.quest_unit_nearst_nearby_tile(origin,nearst.id)
	var action = Action.new(agent.id,&"move")

	await action.before_target_chose()
	action.set_target(target)
	await action.before_run()
	
	## 处理距离过远的问题
	# 判断距离并重设坐标
	var rrange = action.clac_action_range()
	if action.is_target_valid(rrange):
		return action
	else:
		var min_pos := Vector2i.MAX
		# 重设为距离最近的坐标
		var player_pos = min_pos
		min_pos = rrange[0]
		for r in rrange:
			var distance = r.distance_to(player_pos)
			var last_distance = r.distance_to(player_pos)
			if distance < last_distance:
				min_pos = r
				action.change_target(min_pos)
		return action
	

func _get_near_pos(c1:Character,c2:Character):
	var origin:Vector2i = LevelHandler.get_unit_position(agent.id)
	var p1 = LevelHandler.get_unit_position(c1.id)
	var p2 = LevelHandler.get_unit_position(c2.id)
	if origin.distance_to(p1) < origin.distance_to(p2):
		return c1
	else:
		return c2
