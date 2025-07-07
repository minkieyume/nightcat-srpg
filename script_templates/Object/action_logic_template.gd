# meta-name: ActionLogic
# meta-description: 行动的逻辑
# meta-default: true
# meta-space-indent: 4
extends ActionLogic

func action_prerun(action:Action) -> int:
	return 1

func execute(character:String,target:Vector2i,handler:LevelHandler) -> bool:
	print(character.name,grid_map.tile_set.tile_size,target)
	return true
