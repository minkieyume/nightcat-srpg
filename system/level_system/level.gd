class_name Level
extends Node2D
# 游戏关卡、场景的封装类

var character_list:Array

@onready var characters = $Characters
@onready var grid_drawer = $GridDrawer

func _ready() -> void:
	character_list = pack_nodes_to_array(characters,character_list)

func pack_nodes_to_array(nodes:Node,array:Array) -> Array:
	for node in nodes.get_children():
		array.append(node)
	return array

func get_character_list() -> Array[Character]:
	return character_list

func get_character(id:int):
	return character_list[id]
