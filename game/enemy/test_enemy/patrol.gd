extends AIPhase

func before_action():
	agent.update_sight_units()
	var sc:Array = agent.in_sight_units
	var qu:Array = agent.question_units
	sc = sc.filter(func(u):return LevelHandler.is_unit_in_group(u,"player"))
	qu = qu.filter(func(u):return LevelHandler.is_unit_in_group(u,"player"))	
	if sc.is_empty() and qu.is_empty():
		return
	dispatch("find_enemy")
		
