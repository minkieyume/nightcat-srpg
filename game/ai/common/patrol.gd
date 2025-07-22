extends AIPhase

var path:Array[Vector2i] = []
var back_path:Array[Vector2i] = []
var point

func before_action():
	agent.update_sight_units()	
	var qu:Array = agent.found_units.keys()
	qu = qu.filter(func(u):return LevelHandler.is_unit_in_group(u,"player"))
	if !qu.is_empty():
		dispatch("find_enemy")

func get_next_action():
	## point非空时才会获取point
	var pos = LevelHandler.get_unit_position(agent.id)
	if pos == point:
		point = null
	if !point:
		if path.is_empty():
			if !back_path.is_empty():
				point = back_path.pop_front()
			else:
				path = agent.get_patrol_path()
				back_path = path.duplicate()
				back_path.reverse()
		if !path.is_empty():
			point = path.pop_front()			

	if !point:
		return null

	return await AiToolkit.move_near_action(agent,point)
