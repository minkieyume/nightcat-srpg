extends ActionLogic

func execute(action:Action):
	var unit = Unit.new()
	var quester = LevelHandler.get_grid_quester()
	var ghosts = LevelHandler.get_units().filter(func(g):
		return LevelHandler.is_unit_in_group(g.id,"ghost"))
	unit.id = "ghost"+"%d"%ghosts.size()
	unit.position = quester.quest_tile_position(action.target)
	LevelHandler.add_unit(unit)
	
