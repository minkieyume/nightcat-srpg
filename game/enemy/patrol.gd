extends StateAIState

func _state_logic(handler:LevelHandler):
	pass
	# var factory = handler.get_action_factory()
	# var self_pos = handler.get_character_position(agent.id)

	# var action:Action = factory.create_action(agent.id,&"move",self_pos+Vector2i(1,1))
	# action.execute()

func _transition_precheck(handler:LevelHandler):
	agent.update_sight_character(handler) # 此方法后面移到阶段中最好。
	var sc:Array = agent.in_sight_characters
	if !sc.is_empty():
		dispatch("find_enemy")
		
