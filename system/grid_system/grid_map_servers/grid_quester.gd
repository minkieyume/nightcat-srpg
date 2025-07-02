class_name GridQuester
## 从地图中查询信息并返回
extends Node

## 关卡管理器
@export var level_handler:LevelHandler

func _ready() -> void:
	level_handler.grid_quester = self

## 在给定位置搜寻匹配的角色，返回角色id，如果没有则返回空字符串
func quest_character(target:Vector2i) -> String:
	var character_list = level_handler.get_character_dict()
	var grid_map = level_handler.get_grid_map()
	for character_key in character_list.keys():
		var character = character_list[character_key]
		if grid_map.local_to_map(character.position) == target:
			return character_key
	return ""

## 在给定位置搜寻可互动物体，返回物体id，如果没有则返回空字符串
func quest_interactable(target:Vector2i) -> String:
	var interactable_list = level_handler.get_interactable_list()
	var grid_map = level_handler.get_grid_map()
	for ikey in interactable_list.keys():
		var character = interactable_list[ikey]
		if grid_map.local_to_map(character.position) == target:
			return ikey
	return ""

## 获取图块坐标。
func quest_tile_position(target:Vector2i) -> Vector2:
	var grid_map = level_handler.get_grid_map()
	return grid_map.map_to_local(target)
	
## 获取图块中点坐标。
func quest_tile_center(target:Vector2i) -> Vector2:
	var grid_map = level_handler.get_grid_map()
	var tile_pos = grid_map.map_to_local(target)
	var tile_size = grid_map.tile_set.tile_size
	return tile_pos+Vector2(tile_size/2)
