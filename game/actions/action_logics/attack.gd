extends ActionLogic

func execute(character:String,target:Vector2i,handler:LevelHandler) -> bool:
	var chara = handler.get_character(character)
	chara.apply_damage(1)
	return true
