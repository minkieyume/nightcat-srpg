class_name GridQuester
extends Node
# 用于从地图中查询信息并返回

@export var grid_map:TileMapLayer

var tile_size:Vector2i

func _ready() -> void:
	tile_size = grid_map.tile_set.tile_size

func quest_character(target:Vector2i):
	for character in get_tree().get_nodes_in_group("character"):
		if grid_map.local_to_map(character.position) == target:
			return character
	return null
