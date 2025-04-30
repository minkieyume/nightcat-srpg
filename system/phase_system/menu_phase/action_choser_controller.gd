extends MenuPhase

"""Transition：
"chose_target" -> grid_target_choser
"""

"""上下文：
target:Vector2i TargetChoser选中的目标，通常是一个坐标。
target_chose_event:StringName TargetChoser选中后触发的事件，决定转换到哪个节点。
action_list: 角色的行动列表
chosed_action: ActionChoser选中的行动。
"""
@export var grid_quester:GridQuester

func _ready() -> void:
	super()
	add_event_handler("action_chosed",_on_action_chosed)

func _enter() -> void:
	super()
	_update_action_list()

func _update_action_list():
	var action_target = grid_quester.quest_character(context["target"])
	update_context("action_list",level_handler.get_character_actions(action_target))

func _on_action_chosed() -> bool:
	print(context["chosed_action"])
	return true
