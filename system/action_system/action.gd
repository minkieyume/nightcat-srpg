class_name Action
extends Node

@export var action_name:String = "行动" #显示名字
@export var action_range:ActionRange
var character:NodePath

func act(target:Vector2i):
	var c = get_node(character)
	print(c.name,target)
