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
		reduce(func(c1,c2):return AiToolkit.get_near_pos(agent,c1,c2))
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
		var move_action = await AiToolkit.get_move_near_character_action()
		if move_action != null:
			var result = await move_action.precheck()
			if result:
				return move_action
	else:
		if nearby_player.size() > 0:
			var rand_player_index = randi()%(nearby_player.size())
			var player = nearby_player[rand_player_index-1]
			var p_pos = LevelHandler.get_unit_position(player.id)
			return await AiToolkit.random_chose_action(agent,p_pos)
		else:
			return false

