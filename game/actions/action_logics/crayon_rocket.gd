extends ActionLogic

func precheck(action:Action) -> bool:
	var quester = LevelHandler.get_grid_quester()
	var unit = LevelHandler.get_unit(quester.quest_unit(action.target))
	if unit:
		return true
	return false

# 蜡笔飞弹：破坏机关或者缴械敌人。
func execute(action:Action):
	var quester = LevelHandler.get_grid_quester()
	var unit_id = quester.quest_unit(action.target)
	var unit:Unit = LevelHandler.get_unit(unit_id)
	if LevelHandler.is_unit_in_group(unit_id,"enemy"):
		# 缴械效果，未实现
		pass
	elif LevelHandler.is_unit_in_group(unit_id,"breakable"):
		unit.on_break()
