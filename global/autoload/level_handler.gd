extends Node
# 代理对关卡内容的访问与操作
var level:Level

signal level_ready

func level_init(l:Level):
	level = l
	emit_signal("level_ready")

func get_grid_drawer() -> GridDrawer:
	return level.get_grid_drawer()

func get_character_actions(id:String):
	var character = get_character(id)
	return character.get_action_list()

func get_character_action(id:String,action_id:StringName):
	var character = get_character(id)
	return character.get_action_resource(action_id)

func is_unit_in_group(uid:String,group:String) -> bool:
	var unit = get_unit(uid)
	if unit.is_in_group(group):
		return true
	else:
		return false

@rpc("authority","call_local")
func execute_action(r:String,id:StringName,target:Vector2i,ap_coast:int,ctx:Dictionary):
	var action = Action.new(r,id)	
	action.set_target(target)
	action.set_ap_cost(ap_coast)
	action.set_ctx(ctx)
	action.execute()

func cat_execute_action(action:Action):
	if MultiCat.should_sync():
		rpc("execute_action",action.requester,action.resource.id,action.target,action.ap_cost,action.ctx)
	else:
		action.execute()

## 获取单位坐标，未找到则返回 (-9223372036854775808,-9223372036854775808)
func get_unit_position(id:String) -> Vector2i:
	var unit = get_unit(id)
	var grid_map = get_grid_map()
	if is_instance_valid(unit) and is_instance_valid(grid_map):
		return grid_map.local_to_map(unit.position)
	return Vector2i(-9223372036854775808,-9223372036854775808)

func get_grid_map() -> TileMapLayer:
	return level.get_grid_map()

func get_grid_quester() -> GridQuester:
	return level.get_grid_quester()

func get_unit(id:String):
	return level.get_unit(id)

func get_units() -> Array[Unit]:
	return level.get_units()

func get_unit_ids() -> Array[String]:
	return level.get_unit_ids()

func get_character(id:String):
	var c = level.get_unit(id)
	if c is Character:
		return c
	else:
		return null

func get_camera() -> PhantomCamera2D:
	return level.get_camera()

func get_character_ids() -> Array[String]:
	var results = []
	var cs = get_characters()
	for c in cs:
		results.append(c)
	return cs
	
func get_characters() -> Array:
	var units = get_units()
	return units.filter(func(c):return c is Character)

func get_players() -> Array[Character]:
	return get_characters().filter(func(e):return e.is_in_group("player"))

func get_enemies() -> Array[Character]:
	return get_characters().filter(func(e):return e.is_in_group("enemy"))

func get_movement_server() -> MovementServer:
	return level.get_movement_server()
