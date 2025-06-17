extends ActionLogic

func execute(character:String,target:Vector2i,handler:LevelHandler) -> bool:
	handler.send_command("move_character",[character,target])
	var agent = handler.get_character(character)
	await agent.path_end
	return true

#func execute(character:Character,grid_map:TileMapLayer,\
#	target:Vector2i) -> bool:
#	character.request_move_to(target)
#	return true
