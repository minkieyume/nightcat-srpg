extends ActionLogic

func execute(action:Action) -> bool:
	var grid_quester = LevelHandler.get_grid_quester()
	var ikey = grid_quester.quest_unit(action.target)
	if ikey == "":
		return false
	var unit = LevelHandler.get_unit(ikey)
	if unit.is_in_group("machine"):
		CommandBus.server_local_command("gamephase",["setcargo","interactable",unit.id])
		CommandBus.server_local_command("gamephase",["setcargo","mode","before_interact"])
		CommandBus.server_local_command("gamephase",["interact"])
		await unit.interact_end
		return true
	else:
		return false
