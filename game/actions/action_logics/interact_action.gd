extends ActionLogic

func execute(character:String,target:Vector2i,handler:LevelHandler) -> bool:
	var grid_quester = handler.get_grid_quester()
	var ikey = grid_quester.quest_interactable(target)
	if ikey != "":
		var interactable = handler.get_interactable(ikey)
		handler.send_command("setcargo",["interactable",interactable.id])
		await interactable.interact(character,handler,{})
		handler.send_command("menu",["interact",interactable.id])
		return true
	else:
		return false
