class_name LevelHandler
extends Node
# 代理对关卡内容的访问与操作
@export var level:Level

func get_grid_drawer() -> GridDrawer:
	return level.grid_drawer

func get_character_actions(id:int):
	var character = get_character(id)
	return character.get_action_list()

func get_character_list() -> Array[Character]:
	return level.character_list

func get_character(id:int):
	return level.character_list[id]

func local_to_map(local:Vector2) -> Vector2i:
	var grid_map = level.grid_map
	return grid_map.local_to_map(local)

func map_to_local(map:Vector2i) -> Vector2:
	var grid_map:TileMapLayer = level.grid_map
	return grid_map.map_to_local(map)
