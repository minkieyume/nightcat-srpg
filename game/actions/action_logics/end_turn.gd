extends ActionLogic

func execute(character:String,target:Vector2i,handler:LevelHandler) -> bool:
	handler.send_command("gamephase",["turn_end"])
	return true
