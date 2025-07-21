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
	AiToolkit.update_face_to_unit(agent,true)
	agent.update_sight_view()
	agent.update_sight_units()
	
	var sc:Array = agent.found_units.keys()
	if sc.is_empty():
		dispatch("lost_enemy")

func get_next_action():	
	var target_units = agent.found_units
	var ap = agent.get_ap()
	if ap <= 0:
		return null
			
	var in_range_players = target_units.keys().\
		filter(func(c):return LevelHandler.is_unit_in_group(c,"player")).\
		filter(func(c):return await AiToolkit.is_unit_in_action_range(c,agent))
			
	in_range_players.sort_custom(func(u1,u2):return target_units[u1]>target_units[u2])

	if in_range_players.is_empty():
		var move_action = await AiToolkit.move_near_weight_units_action(agent)
		if move_action != null:
			var result = await move_action.precheck()
			if result:
				return move_action
	else:		
		for player in in_range_players:
			var in_range_actions = await AiToolkit.get_action_unit_in_range(player,agent)
			print(in_range_actions)
			var p_pos = LevelHandler.get_unit_position(player)
			return await AiToolkit.random_chose_action\
				(agent,p_pos,func(a:ActionResource):return a.id in in_range_actions)
	return null
