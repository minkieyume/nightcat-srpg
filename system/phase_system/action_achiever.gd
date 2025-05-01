extends Phase

"""Transition：
"finished" -> action_choser
"""

"""上下文：
target:Vector2i 选中的目标，通常是一个坐标。
target_chose_event:StringName TargetChoser选中后触发的事件，决定接下来转换到哪个节点
chosed_action: ActionChoser选中的行动。
"""

func _enter():
	super()
	var character:Character = level_handler.get_character(context["actor"])
	character.request_action(context["chosed_action"],context["target"])
