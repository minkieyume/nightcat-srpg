class_name Level
extends Node2D
# 游戏关卡、场景的封装类
# 负责封装角色、敌人、机关、物件、场景事件、剧情、场景特效、区域触发、地图、音效等场景要素。并提供访问

func _ready() -> void:
	pass

func pack_nodes(nodes:Node,array:Array) -> Array:
	for node in nodes.get_children():
		array.append(node)
	return array

func pack_nodes_to_dict(nodes:Node,dict:Dictionary) -> Dictionary:
	for node in nodes.get_children():
		if node.is_in_group("id"):
			dict.set(node.id,node)
		else:
			assert(false,"[Level]输入的node对象必须在id组中且实现了id变量才可包装为字典。")
	return dict

func get_grid_map() -> TileMapLayer:
	return TileMapLayer.new()

func get_grid_drawer() -> GridDrawer:
	return GridDrawer.new()

func get_character_owners() -> Dictionary[String,CharacterOwner]:
	return {"test":CharacterOwner.new()}

func get_character_dict() -> Dictionary[String,Character]:
	return {"test":Character.new()}

func get_character_array() -> Array[Character]:
	return [Character.new()]

func get_character(id:String):
	return Character.new()
