extends Phase

"""Transition：
"action_finish" -> turn_end
"action_failed" -> action_choser
"""

"""接收的上下文：
master:String 角色拥有者的ID
actor:String 角色的ID
target:Vector2i 选中的目标，通常是一个坐标。
chosed_action: ActionChoser选中的行动。
"""

"""传递的上下文：
target_chose_event:StringName TargetChoser选中后触发的事件，决定接下来转换到哪个节点
"""

var achieve_action:Action

func _enter():
	super()
	var action = context["action"]
	if action is Action:
		achieve_action = action
		achieve_action.set_target(context["target"])
		context.erase("target")
		achieve_action.finished.connect(_action_finish)
		achieve_action.failed.connect(_action_failed)
		achieve_action.execute()

func _exit():
	super()
	context.erase("actor")
	context.erase("target")
	call_deferred("clean_action")
	
func clean_action():
	context.erase("action")
	achieve_action.free()

func _action_finish():
	context["target_chose_event"] = &"character_chose"	
	dispatch("action_finish")

func _action_failed():
	print("[DEBUG] 行动执行失败")
	context["target_chose_event"] = &"character_chose"
	dispatch("action_fail")
