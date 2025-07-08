extends ActionLogic

func execute(_action:Action) -> bool:
	CommandBus.call_deferred("send_command","gamephase",["turn_end"])
	return true
