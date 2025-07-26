class_name Level
extends Node2D
# 游戏关卡、场景的封装类
# 负责封装角色、敌人、机关、物件、场景事件、剧情、场景特效、区域触发、地图、音效等场景要素。并提供访问

var unit_dict:Dictionary[String,Unit]

func _ready() -> void:
	LevelHandler.level_init(self)

func pack_nodes(nodes:Node) -> Array:
	var array = Array()
	for node in nodes.get_children():
		array.append(node)
	return array

func pack_nodes_to_dict(nodes:Node) -> Dictionary:
	var dict = Dictionary()
	for node in nodes.get_children():
		if node.is_in_group("id"):
			dict.set(node.id,node)
		else:
			assert(false,"[Level]输入的node对象必须在id组中且实现了id变量才可包装为字典。")
	return dict

func get_grid_map_layers() -> Array[GridMapLayer]:
	return [GridMapLayer.new()]

func get_grid_drawer() -> GridDrawer:
	return GridDrawer.new()

func get_unit(unit_id) -> Unit:
	return unit_dict.get(unit_id)

func get_units() -> Array[Unit]:
	return unit_dict.values()

func get_unit_ids() -> Array[String]:
	return unit_dict.keys()

func get_grid_quester() -> GridQuester:
	return GridQuester.new()

func get_movement_server() -> MovementServer:
	return MovementServer.new()

func get_camera() -> PhantomCamera2D:
	return PhantomCamera2D.new()

func remove_unit(unit:String):
	if unit_dict.has(unit):
		var unit_entity = unit_dict[unit]
		unit_dict.erase(unit)
		unit_entity.queue_free()

func add_unit(unit:Unit):
	unit_dict[unit.id] = unit
