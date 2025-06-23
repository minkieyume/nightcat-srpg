extends MenuPhase

"""Transition：
"chose_action_target" -> grid_target_choser
"""

"""上下文：
target:Vector2i TargetChoser选中的目标，通常是一个坐标。
target_chose_event:StringName TargetChoser选中后触发的事件，决定转换到哪个节点。
actor: String 行动的发起者与执行者，用id表示。
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
	var actor_id = context["actor"]
	if typeof(actor_id) == TYPE_STRING:
		var action_list = level_handler.get_character_actions(actor_id)
		if action_list == null:
			push_error("[action_choser_controller.gd] 获取角色行动列表失败，actor_id: %s" % [str(actor_id)])
		else:
			update_context("action_list", action_list)
	else:
		push_error("[action_choser_controller.gd] context['actor'] 不是 int，当前值：%s" % [str(actor_id)])

func _update_actor():
	var id = grid_quester.quest_character(context["target"])
	context["actor"] = id

func _on_action_chosed() -> bool:
	context.erase("target")
	context.erase("action_list")
	context["target_chose_event"] = &"action_target_chose"
	dispatch("chose_action_target")
	return true
