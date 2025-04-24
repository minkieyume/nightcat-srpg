class_name ActionLogic
extends Object
# 行动的抽象接口

func execute(character:Character,grid_map:TileMapLayer,\
	target:Vector2i) -> bool:
	print(character.name,grid_map.tile_set.tile_size,target)
	return true
