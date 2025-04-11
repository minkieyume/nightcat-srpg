class_name ActionManager
extends Node
@export_node_path("Character") var character = NodePath("..")
@export var actions:Array[Action]

var action_list = {}

func _ready() -> void:
	for action in actions:
		action_list[action.id] = action

func execute_action(id:StringName,target:Vector2i) -> bool:
	#执行一个行动，成功返回true，失败返回false
	if action_list.has(id):
		return action_list[id]._execute(get_node(character),target)
	else:
		push_error("角色没有该行动")
		return false

