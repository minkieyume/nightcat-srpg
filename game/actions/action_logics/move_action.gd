extends ActionLogic

func execute(character:Character,grid_map:TileMapLayer,\
	target:Vector2i) -> bool:
	character.request_move_to(target)
	return true

