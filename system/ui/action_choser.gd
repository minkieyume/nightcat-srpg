extends MenuState

"""Transition：
"chose_target" -> grid_target_choser
"""

"""上下文：
target_chose_event:StringName TargetChoser选中后触发的事件，决定转换到哪个节点。
"""

func _enter() -> void:
	super()
	print("action_chosing")

func _on_action_chosed():
	context["action"] = "move"
