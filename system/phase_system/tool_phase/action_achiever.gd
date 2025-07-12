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
action_ctx:Dictionary 预检查上下文，通常是个字典。
"""

"""传递的上下文：
target_chose_event:StringName TargetChoser选中后触发的事件，决定接下来转换到哪个节点
"""

# func _setup() -> void:
# 	add_event_handler("precheck_continue",_handle_precheck_continue)

func _enter():
	super()
	match context["mode"]:
		"start_action":
			var action = Action.from_dict(context["action"])
			action.set_ctx(context)
			context.erase("target")			
			LevelHandler.cat_execute_action(action.to_dictionary())
		"end_action":
			call_deferred("dispatch","next")
		
func _exit():
	super()
	match context["mode"]:
		"end_action":			
			context.erase("target")
			context.erase("action")
