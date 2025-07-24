extends ActionLogic

func precheck(action:Action) -> bool:
	var grid_quester = LevelHandler.get_grid_quester()
	var ikey = grid_quester.quest_unit(action.target)
	if ikey == "":
		return false
	var unit = LevelHandler.get_unit(ikey)
	if unit.is_in_group("telekable"):
		return true
	else:
		return false

func execute(action:Action):
	var grid_quester = LevelHandler.get_grid_quester()
	var target_choser:GridTargetChoserController = MenuHandler.get_grid_target_choser()
	var unit = grid_quester.quest_unit(action.target)
	CommandBus.send_command("menu",["setcargo","mode","inaction_menu"])
	CommandBus.send_command("menu",["setcargo","_action",action])
	CommandBus.send_command("menu",["chose_target"])
	await target_choser.grid_chosed
	if action.ctx.has("target"):
		var movement = LevelHandler.get_movement_server()
		movement.rpc("move_unit",unit,action.ctx["target"])
		await LevelHandler.get_unit(unit).path_end
	else:
		if MultiCat.is_online():
			if action.ctx.has("part"):
				var agents = MultiCat.get_agents()
				var player_id = MultiCat.multiplayer.get_unique_id()
				var agen = agents["%d"%player_id]
				if agen.part == action.ctx["part"]:
					action.no_cost = true
		else:
			action.no_cost = true

