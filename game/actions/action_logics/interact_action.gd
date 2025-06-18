extends ActionLogic

func execute(character:String,target:Vector2i,handler:LevelHandler) -> bool:
	handler.send_command("interact_interactable",[character,target])
	return true
