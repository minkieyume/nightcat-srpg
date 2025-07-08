extends ActionLogic

func execute(action:Action) -> bool:
	var grid_quester = LevelHandler.get_grid_quester()
	var ikey = grid_quester.quest_unit(action.target)
	if ikey != "":
		var unit = LevelHandler.get_unit(ikey)
		if unit.is_in_group("interactable"):
			CommandBus.send_command("gamephase",["setcargo","interactable",unit.id])
			CommandBus.send_command("gamephase",["setcargo","mode","before_interact"])
			CommandBus.send_command("gamephase",["interact"])
			await unit.interact_end
			return true
	return false
