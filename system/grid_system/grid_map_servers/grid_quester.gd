class_name GridQuester
extends Node
# 用于从地图中查询信息并返回

@export var level_handler:LevelHandler

func quest_character(target:Vector2i) -> int:
	# 搜寻与特定网格位置匹配的角色并返回id
	var character_list = level_handler.get_character_list()
	for character in character_list:
		if level_handler.local_to_map(character.position) == target:
			return character_list.find(character)
	return -1
