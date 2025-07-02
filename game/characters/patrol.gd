extends StateAIState

func _state_logic(handler:LevelHandler):	
	var factory = handler.get_action_factory()
	var self_pos = handler.get_character_position(agent.id)

	var action:Action = factory.create_action(agent.id,&"move",self_pos+Vector2i(1,1))
	action.execute()

func _transition_precheck(handler:LevelHandler):
	print("执行预检查")
	var players = get_tree().get_nodes_in_group("player")
	
	for player in players:
		var pos = handler.get_character_position(player.id)
		var sight_radius:SightRadius = agent.sight_radius
		if sight_radius.is_tile_in_radius(pos,handler.get_grid_quester()):
			dispatch("find_enemy")
		
