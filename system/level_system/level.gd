class_name Level
extends Node2D
# 游戏关卡、场景的封装类
# 负责封装角色、敌人、机关、物件、场景事件、剧情、场景特效、区域触发、地图、音效等场景要素。

var character_list:Array[Character]

@onready var characters = $Characters
@onready var grid_map:TileMapLayer =  $GridMap
@onready var grid_drawer:GridDrawer = $GridDrawer

func _ready() -> void:
	character_list = pack_nodes_to_array(characters,character_list)

func pack_nodes_to_array(nodes:Node,array:Array) -> Array:
	for node in nodes.get_children():
		array.append(node)
	return array
