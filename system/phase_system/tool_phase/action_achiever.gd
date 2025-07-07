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

var achieve_action:Action

# func _setup() -> void:
# 	add_event_handler("precheck_continue",_handle_precheck_continue)

func _enter():
	super()
	if context.has("mode"):
		if context["mode"] == "end_action":
			return
	if context.has("action"):
		var action = context["action"]
		if action is Action:			
			achieve_action = action
			achieve_action.set_target(context["target"])
			context.erase("target")				
			achieve_action.finished.connect(_action_finish)
			achieve_action.failed.connect(_action_failed)
			var precheck = await achieve_action.prerun()
			match precheck:
				0:
					_precheck_failed()
				1:
					achieve_action.execute()

func _exit():
	super()
	if context.has("mode"):
		if context["mode"] == "end_action":
			call_deferred("clean_action")
	elif !context.has("action_ctx"):
		call_deferred("clean_action")
	
func clean_action():
	context["mode"] = "default"
	context.erase("actor")
	context.erase("target")
	context.erase("action")
	achieve_action.free()

func _action_finish():
	context["target_chose_event"] = &"character_chose"	
	dispatch("action_finish")

func _action_failed():
	print("[DEBUG] 行动执行失败")
	context["target_chose_event"] = &"character_chose"
	dispatch("action_failed")

func _precheck_failed():
	print("[DEBUG] 行动预检查失败")
	context["target_chose_event"] = &"character_chose"
	dispatch("precheck_failed")

func _handle_precheck_continue() -> bool:
	var dict:Dictionary = context["action_ctx"]
	if dict.has("target_chose_event"):
		context["target_chose_event"] = dict["target_chose_event"]
		dispatch("precheck_chose_target")
	return true

func _on_level_handler_command_send(command:StringName, args:Array) -> void:
	if command == "setcargo":
		context[args[0]] = args[1]
