class_name LevelHandler
extends Node
# 代理对关卡内容的访问与操作
@export var level:Level
@export var movement_server: Node
@export var grid_quester:GridQuester
@export var action_factory:ActionFactory

signal command_send(command:StringName,args:Array)

func get_grid_drawer() -> GridDrawer:
	return level.get_grid_drawer()

func get_character_actions(id:String):
	var character = get_character(id)
	return character.get_action_list()

func get_character_action(id:String,action_id:StringName):
	var character = get_character(id)
	return character.get_action_resource(action_id)

## 获取角色坐标，未找到则返回 (-9223372036854775808,-9223372036854775808)
func get_character_position(id:String) -> Vector2i:
	var character = get_character(id)
	var grid_map = level.get_grid_map()
	if is_instance_valid(character) and is_instance_valid(grid_map):
		return grid_map.local_to_map(character.position)
	return Vector2i(-9223372036854775808,-9223372036854775808)

## 获取可互动体坐标，未找到则返回 (-9223372036854775808,-9223372036854775808)
func get_interactable_position(id:String) -> Vector2i:
	var interactable = get_interactable(id)
	var grid_map = level.get_grid_map()
	if is_instance_valid(interactable) and is_instance_valid(grid_map):
		return grid_map.local_to_map(interactable.position)
	return Vector2i(-9223372036854775808,-9223372036854775808)

func get_character_dict() -> Dictionary[String,Character]:
	return level.get_character_dict()

func get_character_array() -> Array[Character]:
	return level.get_character_array()

func get_character(id:String):
	return level.get_character(id)

func get_character_owner(id:String):
	var cdict = level.get_character_owners()
	return cdict.get(id)

func get_grid_map() -> TileMapLayer:
	return level.get_grid_map()

func get_interactable(id:String) -> Interactable:
	return level.get_interactable(id)

func get_interactable_list() -> Dictionary[String,Interactable]:
	return level.get_interactable_dict()

func get_grid_quester() -> GridQuester:
	return grid_quester

func get_action_factory() -> ActionFactory:
	return action_factory

func get_player_list() -> Array[Character]:
	return get_character_array().filter(_player_fliter)

func get_enemy_list() -> Array[Character]:
	return get_character_array().filter(_enemy_fliter)

func get_movement_server() -> MovementServer:
	return movement_server

func _player_fliter(enemy:Character) -> bool:
	if enemy.is_in_group("player"):
		return true
	else:
		return false

func _enemy_fliter(enemy:Character) -> bool:
	if enemy.is_in_group("enemy"):
		return true
	else:
		return false

func send_command(command:StringName,args:Array):
	emit_signal("command_send",command,args)

# 修正：路径长度实际为格数（即 path.size()-1），但ap消耗应为最大允许AP与实际路径长度的较小值
func get_path_length(start: Vector2i, target: Vector2i) -> int:
	if movement_server:
		var length = movement_server.get_path_length(start, target)
		return max(length, 0)		
	return 1
