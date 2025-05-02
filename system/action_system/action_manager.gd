class_name ActionManager
extends Node
@export_node_path("Character") var character = NodePath("..")
@export var actions:Array[ActionResource]

var action_list = {}

func _ready() -> void:
	for action in actions:
		action_list[action.id] = action

func get_action_resouce(id:StringName):
	return action_list[id]
