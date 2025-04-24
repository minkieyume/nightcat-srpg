# meta-name: ActionLogic
# meta-description: 行动的逻辑接口
# meta-default: true
# meta-space-indent: 4
extends ActionLogic

func execute(character:Character,grid_map:TileMapLayer,\
	target:Vector2i) -> bool:
	print(character.name,grid_map.tile_set.tile_size,target)
	return true
