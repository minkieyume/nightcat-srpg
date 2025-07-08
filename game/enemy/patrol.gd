extends StateAIState

func _state_logic():
	pass
	# var factory = LevelHandler.get_action_factory()
	# var self_pos = LevelHandler.get_character_position(agent.id)

	# var action:Action = factory.create_action(agent.id,&"move",self_pos+Vector2i(1,1))
	# action.execute()

func before_action():
	agent.update_sight_units()
	var sc:Array = agent.in_sight_units
	if !sc.is_empty():
		dispatch("find_enemy")
		
