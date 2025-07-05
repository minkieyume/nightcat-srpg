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

@export var action_factory:ActionFactory
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
	var actor = grid_quester.quest_character(context["target"])
	if actor != "":
		context["actor"] = actor
	else:
		dispatch("return")

func _create_action():
	var character_owner = level_handler.get_character_owner(context["master"])
	if character_owner and character_owner.is_character_handled(context["actor"]):
		var action:Action = action_factory.create_action(context["actor"], context["chosed_action"])
		context["action"] = action
		var action_range = action.clac_action_range()
		context["action_limit"] = action_range
	else:
		print("[ActionChoser] 请选择有控制权的角色")
		dispatch("return")

func _on_action_chosed() -> bool:
	context.erase("target")
	context.erase("action_list")
	_create_action()
	context["target_chose_event"] = &"action_target_chose"	
	dispatch("chose_action_target")
	return true

func _return() -> bool:
	context.erase("target")
	context.erase("action_list")
	context.erase("action")
	dispatch("back")
	return true

func _on_ui_canceled():
	print("action-return")
	dispatch("return")
