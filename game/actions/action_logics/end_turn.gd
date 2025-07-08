extends ActionLogic

func execute(_action:Action) -> bool:
	LevelHandler.send_command("gamephase",["turn_end"])
	return true
