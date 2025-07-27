extends ActionLogic

func precheck(action:Action) -> bool:
	var quester = LevelHandler.get_grid_quester()
	var unit = LevelHandler.get_character(quester.quest_unit(action.target))
	if unit:
		return true
	return false

# 夜猫嘲讽：吸引对应角色仇恨。
func execute(action:Action):
	var quester = LevelHandler.get_grid_quester()
	var unit_id = quester.quest_unit(action.target)
	var unit:Unit = LevelHandler.get_unit(unit_id)
	var found = unit.found_units
	var requester = action.requester
	if found.has(requester):
		unit.discover_unit(requester,found[requester])
	else:
		unit.discover_unit(requester,10)
