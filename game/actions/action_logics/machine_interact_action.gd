extends ActionLogic

func execute(character:String,target:Vector2i,handler:LevelHandler) -> bool:
	var grid_quester = handler.get_grid_quester()
	var ikey = grid_quester.quest_interactable(target)
	if ikey != "":
		var interactable = handler.get_interactable(ikey)
		if interactable.is_in_group("machine"):
			handler.send_command("setcargo",["interactable",interactable.id])
			handler.send_command("setcargo",["mode","before_interact"])
			handler.send_command("menu",["interact"])
			await interactable.finished
			handler.send_command("menu",["finished"])
			return true
	return false
