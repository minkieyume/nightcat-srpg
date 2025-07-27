extends ActionLogic

func precheck(action:Action) -> bool:
	var quester = LevelHandler.get_grid_quester()
	var unit = LevelHandler.get_unit(quester.quest_unit(action.target))
	if unit:			
		if LevelHandler.is_unit_in_group(unit.id,"enemy"):
			if unit.has_buff("trip") or unit.has_buff("fear"):
				return true
	return false

# 蜡笔重击：对敌人进行处决一击
func execute(action:Action):
	var quester = LevelHandler.get_grid_quester()
	var unit_id = quester.quest_unit(action.target)
	var unit:Character = LevelHandler.get_unit(unit_id)
	var damage:int = action.args["damage"]
	unit.apply_damage(damage)
