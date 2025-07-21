extends AIPhase

func before_action():
	agent.update_sight_units()	
	var qu:Array = agent.found_units.keys()	
	qu = qu.filter(func(u):return LevelHandler.is_unit_in_group(u,"player"))
	if !qu.is_empty():
		dispatch("find_enemy")
	
		
