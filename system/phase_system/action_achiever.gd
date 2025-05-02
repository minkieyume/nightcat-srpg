extends Phase

"""Transition：
"action_end" -> action_choser
"""

"""上下文：
target:Vector2i 选中的目标，通常是一个坐标。
target_chose_event:StringName TargetChoser选中后触发的事件，决定接下来转换到哪个节点
chosed_action: ActionChoser选中的行动。
"""
@export var action_factory:ActionFactory

var achieve_action:Action

func _enter():
	super()
	achieve_action = \
		action_factory.create_action(context["actor"],context["chosed_action"],context["target"])
	achieve_action.execute()
	await achieve_action.finished
	_action_finish()

func _exit():
	super()
	call_deferred("clean_action")
	
func clean_action():
	achieve_action.free()

func _action_finish():
	context["target_chose_event"] = &"character_chose"
	dispatch("action_end")
