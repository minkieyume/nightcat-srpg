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
	AiToolkit.update_face_to_character(agent)
	agent.update_sight_units()
	agent.clean_question_units()
	
	var sc:Array = agent.in_sight_units
	if sc.is_empty():
		dispatch("lost_enemy")

func get_next_action():
	var quester = LevelHandler.get_grid_quester()
	var ap = agent.get_ap()
	if ap <= 0:
		return null

	var in_range_players = agent.in_sight_units.\
		filter(func(c):return LevelHandler.is_unit_in_group(c,"player")).\
		filter(func(c):return await AiToolkit.is_unit_in_action_range(c,agent))
	
	if in_range_players.is_empty():
		var move_action = await AiToolkit.get_move_near_character_action(agent)
		if move_action != null:
			var result = await move_action.precheck()
			if result:
				return move_action
	else:
		if in_range_players.size() > 0:
			var rand_player_index = randi()%(in_range_players.size())
			var player = in_range_players[rand_player_index-1]
			var in_range_actions = await AiToolkit.get_action_unit_in_range(player,agent)
			var p_pos = LevelHandler.get_unit_position(player)
			return await AiToolkit.random_chose_action\
				(agent,p_pos,func(a:ActionResource):return a in in_range_actions)
		else:
			return null
	return null
