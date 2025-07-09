extends AIPhase

func before_action():
	agent.update_sight_units()
	var sc:Array = agent.in_sight_units
	if !sc.is_empty():
		dispatch("find_enemy")
		
