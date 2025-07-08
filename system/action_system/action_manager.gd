class_name ActionManager
extends Node
@export_node_path("Character") var character = NodePath("..")
@export var actions:Array[ActionResource]

var action_list = {}

# 行动冷却管理
# TODO，待重构和解耦AP机制。
var cooldown_map := {} # key: StringName, value: int

func _ready() -> void:
	for action in actions:
		action_list[action.id] = action

func get_action_resouce(id:StringName):
	return action_list[id]

func get_action_id_list(action_filter:Callable=func(_a):return true) -> Array:
	var result = []
	for id in action_list.keys():
		var action = action_list[id]
		if action_filter.call(action):
			result.append(id)
	return result


# # 检查行动是否可用（AP和冷却）
# func can_execute_action(id: StringName, actor) -> bool:
# 	var action: ActionResource = get_action_resouce(id)
# 	if !action:
# 		return false
# 	if actor.get_ap() < action.ap_cost:
# 		return false
# 	if cooldown_map.get(id, 0) > 0:
# 		return false
# 	return true

# # 执行行动并处理AP与冷却
# func execute_action(id: StringName, target: Vector2i) -> bool:
# 	var action: ActionResource = get_action_resouce(id)
# 	if !action:
# 		return false
# 	var actor_node = get_node(character)
# 	if !can_execute_action(id, actor_node):
# 		return false
# 	if !actor_node.consume_ap(action.ap_cost):
# 		return false
# 	cooldown_map[id] = action.cooldown
# 	# 实例化 Action 并执行
# 	var act = Action.new()
# 	act.requester = actor_node.get_instance_id()
# 	act.target = target
# 	act.resource = action
# 	act.action_range = action.action_range
# 	act.logic = action.action_logic.new()
# 	await act.execute()
# 	return true

# # 回合推进时减少所有冷却
# func tick_cooldown():
# 	for id in cooldown_map.keys():
# 		if cooldown_map[id] > 0:
# 			cooldown_map[id] -= 1
