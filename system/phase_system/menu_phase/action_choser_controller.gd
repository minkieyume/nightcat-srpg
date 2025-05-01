extends MenuPhase

"""Transition：
"chose_action_target" -> grid_target_choser
"""

"""上下文：
target:Vector2i TargetChoser选中的目标，通常是一个坐标。
target_chose_event:StringName TargetChoser选中后触发的事件，决定转换到哪个节点。
actor: int 行动的发起者与执行者，用id表示。
action_list: Dictionary 角色的行动列表
chosed_action: StringName ActionChoser选中的行动。
"""
@export var grid_quester:GridQuester

func _ready() -> void:
	super()
	add_event_handler("action_chosed",_on_action_chosed)

func _enter() -> void:
	super()
	_update_action_list()

func _update_action_list():
	_update_actor()
	update_context("action_list",level_handler.get_character_actions(context["actor"]))

func _update_actor():
	context["actor"] = grid_quester.quest_character(context["target"])

func _on_action_chosed() -> bool:
	context.erase("target")
	context.erase("action_list")
	context["target_chose_event"] = &"action_target_chose"
	dispatch("chose_action_target")
	return true
