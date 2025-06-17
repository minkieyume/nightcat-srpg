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
	var character_controller:CharacterController = level_handler.get_character_controller(context["master"])
	if character_controller and character_controller.is_character_handled(context["actor"]):
		achieve_action = action_factory.create_action(context["actor"], context["chosed_action"], context["target"])
		achieve_action.finished.connect(_action_finish)
		achieve_action.failed.connect(_action_failed)
		achieve_action.execute()

func _exit():
	super()
	call_deferred("clean_action")
	
func clean_action():
	achieve_action.free()

func _action_finish():
	context["target_chose_event"] = &"character_chose"
	dispatch("action_end")

func _action_failed():
	print("[DEBUG] 目标不可达，请重新选择")
	context["target_chose_event"] = &"character_chose"
	dispatch("action_end")
