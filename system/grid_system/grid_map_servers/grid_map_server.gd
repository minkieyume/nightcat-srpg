class_name GridMapServer
extends Node
# 所有GridMap服务器的基类。

@export var grid_map:TileMapLayer

var tile_size:Vector2i

func _ready() -> void:
	tile_size = grid_map.tile_set.tile_size
