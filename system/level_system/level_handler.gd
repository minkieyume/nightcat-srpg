class_name LevelHandler
extends Node
# 代理对关卡内容的访问与操作
@export var level:Level

func get_grid_drawer() -> GridDrawer:
	return level.get_grid_drawer()

func get_character_actions(id:int):
	var character = get_character(id)
	return character.get_action_list()

func get_character_list() -> Array[Character]:
	return level.get_character_list()

func get_character(id:int):
	return level.get_character(id)

func get_grid_map() -> TileMapLayer:
	return level.get_grid_map()
