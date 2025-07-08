extends ActionLogic

func execute(action:Action) -> bool:
	var character = LevelHandler.get_character(action.requester)
	character.apply_damage(1)
	return true
