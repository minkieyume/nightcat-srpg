class_name GridMapServer
extends Node
# 所有GridMap服务器的基类。

var grid_map:TileMapLayer

var tile_size:Vector2i

func _ready() -> void:
	CommandBus.connect("command_send",_on_command_recieved)	
	LevelHandler.level_ready.connect(_on_level_ready)
	

func _on_level_ready():
	grid_map = LevelHandler.get_grid_map()
	tile_size = grid_map.tile_set.tile_size

func _on_command_recieved(command:StringName,args:Array):
	pass
