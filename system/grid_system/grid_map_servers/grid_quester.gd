class_name GridQuester
extends Node
# 用于从地图中查询信息并返回

@export var level_handler:LevelHandler

func quest_character(target:Vector2i) -> String:
	# 搜寻与特定网格位置匹配的角色并返回id
	var character_list = level_handler.get_character_dict()
	var grid_map = level_handler.get_grid_map()
	for character_key in character_list.keys():
		var character = character_list[character_key]
		if grid_map.local_to_map(character.position) == target:
			return character_key
	return ""
