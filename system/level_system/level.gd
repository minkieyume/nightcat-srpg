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

func get_grid_map() -> TileMapLayer:
	return TileMapLayer.new()

func get_grid_drawer() -> GridDrawer:
	return GridDrawer.new()

func get_character_list() -> Array[Character]:
	return [Character.new()]

func get_character(id:int):
	return Character.new()
