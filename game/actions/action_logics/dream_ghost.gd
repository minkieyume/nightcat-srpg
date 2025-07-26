extends ActionLogic

func execute(action:Action):
	var unit = Unit.new()
	var ghosts = LevelHandler.get_units().filter(func(g):
		return LevelHandler.is_unit_in_group(g.id,"ghost"))
	unit.id = "ghost"+"%d"%ghosts.size()
	LevelHandler.add_unit(unit)
	
