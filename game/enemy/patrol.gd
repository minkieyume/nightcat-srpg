extends AIPhase

func before_action():
	agent.update_sight_units()
	var sc:Array = agent.in_sight_units
	sc = sc.filter(func(u):return LevelHandler.is_unit_in_group(u,"player"))	
	if !sc.is_empty():
		dispatch("find_enemy")
		
