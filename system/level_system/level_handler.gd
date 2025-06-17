class_name LevelHandler
extends Node
# 代理对关卡内容的访问与操作
@export var level:Level

signal command_send(command:StringName,args:Array)

func _ready() -> void:
	level.handler = self

func get_grid_drawer() -> GridDrawer:
	return level.get_grid_drawer()

func get_character_actions(id:String):
	var character = get_character(id)
	return character.get_action_list()

func get_character_action(id:String,action_id:StringName):
	var character = get_character(id)
	return character.get_action_resource(action_id)

func get_character_position(id:String) -> Vector2i:
	var character = get_character(id)
	var grid_map = level.get_grid_map()
	if is_instance_valid(character) and is_instance_valid(grid_map):
		return grid_map.local_to_map(character.position)
	return Vector2i.ZERO

func get_character_dict() -> Dictionary[String,Character]:
	return level.get_character_dict()

func get_character_array() -> Array[Character]:
	return level.get_character_array()

func get_character(id:String):
	return level.get_character(id)

func get_character_controller(id:String):
	var cdict = level.get_character_controllers()
	return cdict.get(id)

func get_grid_map() -> TileMapLayer:
	return level.get_grid_map()

func send_command(command:StringName,args:Array):
	emit_signal("command_send",command,args)
