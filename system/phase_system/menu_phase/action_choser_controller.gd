class_name ActionChoserController
extends MenuPhase
## 转换表
## "chose_action_target" -> grid_target_choser
## 
## 上下文：
## target:Vector2i TargetChoser选中的目标，通常是一个坐标。
## target_chose_event:StringName TargetChoser选中后触发的事件，决定转换到哪个节点。
## actor: String 行动的发起者与执行者，用id表示。
## action_list: Dictionary 角色的行动列表
## chosed_action: StringName ActionChoser选中的行动。
## action:Action 具体的行动对象
## action_limit:Array 行动的限制范围数组。

func _ready() -> void:
	super()	
	add_event_handler("action_chosed",_on_action_chosed)

func _enter() -> void:
	super()
	_update_action_list()

func _update_action_list():
	update_context("action_list",LevelHandler.get_character_actions(context["actor"]))

func _exit():
	super()	

func _create_action():
	var action:Action = Action.new(context["actor"], context["chosed_action"])
	context["action"] = action
	action.set_ctx(context)

func _on_action_chosed() -> bool:
	context.erase("target")
	context.erase("action_list")
	await _create_action()
	var action:Action = context["action"]
	await action.before_target_chose()
	if action.has_range():
		context["mode"] = "chose_action_target"
		context["limit_array"] = context["action"].clac_action_range()
		dispatch("chose_target")
	else:
		CommandBus.send_command("gamephase",["setcargo","mode","action_precheck"])
		CommandBus.send_command("gamephase",["setcargo","action",context["action"]]) 
		CommandBus.send_command("gamephase",["setcargo","actor",context["actor"]])
		dispatch("end")
	return true

func _return() -> bool:
	context.erase("actor")
	context.erase("target")
	context.erase("action_list")
	context.erase("action")
	context["mode"] = "chose_action_target"
	CommandBus.cat_send_command("gamephase",["back"])
	dispatch("back")
	return true

func _on_ui_canceled():
	dispatch("return")
