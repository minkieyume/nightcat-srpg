class_name ActionManager
extends Node
@export_node_path("Character") var character = NodePath("..")
@export var actions:Array[ActionResource]

var action_list = {}

func _ready() -> void:
	for action in actions:
		action_list[action.id] = action

func create_action(action_resource:ActionResource,target:Vector2i,\
	grid_map:TileMapLayer) -> Action:
	var action = Action.new()
	var action_logic:GDScript = action_resource.action_logic
	action.resource = action_resource
	action.action_range = action_resource.action_range
	action.logic = action_logic.new()
	action.target = target
	action.grid_map = grid_map
	action.character = get_node(character)
	return action

func change_target(action:Action,target:Vector2i) -> void:
	action.target = target

func execute_action(id:StringName,target:Vector2i,\
	grid_map:TileMapLayer) -> bool:
	#执行一个行动，成功返回true，失败返回false
	if action_list.has(id):
		var action = create_action(action_list[id],target,grid_map)
		return action.execute()
	else:
		push_error("角色没有该行动")
		return false
