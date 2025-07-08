class_name GridTargetChoserController
extends MenuPhase
## 图块选择器控件
## 转换表：
## &"character_chose" -> action_choser
## &"action_target_chose" -> action_achiever
## &"interactable_target_chose" -> interactor
## 
## 上下文：
## target:Vector2i 选中的目标，通常是一个坐标。
## target_chose_event:StringName TargetChoser选中后触发的事件，决定接下来转换到哪个节点
## chosed_action: ActionChoser选中的行动。
## action_limit:Array 行动的限制范围数组。

var grid_drawer:GridDrawer
var limit_mode = false


func _ready() -> void:
	super()
	add_event_handler("chose",_chose)

func _enter() -> void:
	super()
	grid_drawer = LevelHandler.get_grid_drawer()
	grid_drawer.show_highlight = true
	match context["mode"]:
		"chose_action_target":
			var limit_array = context["limit_array"]
			grid_drawer.limit_array = limit_array
			grid_drawer.show_limit = true
			limit_mode = true

func _exit() -> void:
	super()	
	grid_drawer.show_highlight = false
	if limit_mode:
		limit_mode = false
		grid_drawer.show_limit = false
	

func _chose() -> bool:
	var target = get_chosed_target()
	context["target"] = target
	match context["mode"]:
		"chose_character":
			if !is_chosed_actor_vaild(target):
				print("[GridChoser] 选中目标不是角色，请重新选择")
				return true
			dispatch("character_chose")
		"chose_action_target":
			context["action"].set_target(context["target"])
			CommandBus.send_command("gamephase",["setcargo","action",context["action"]])			
			context.erase("target")
			CommandBus.send_command("gamephase",["setcargo","actor",context["actor"]])
			dispatch("action_target_chose")
		"chose_interactable_target":
			CommandBus.send_command("gamephase",["setcargo","target",context["target"]])
			CommandBus.send_command("gamephase",["interact_sucess"])
			context.erase("target")
			dispatch("interactable_target_chose")
	return true

func is_chosed_actor_vaild(target:Vector2i) -> bool:
	var quester = LevelHandler.get_grid_quester()
	return quester.quest_character(target) != ""

func update_target_position(new_pos:Vector2i):
	grid_drawer.highlight = new_pos

func get_chosed_target() -> Vector2i:
	return grid_drawer.highlight

func _return() -> bool:
	match context["mode"]:
		"chose_interactable_target":
			context["mode"] = "chose_character"
			CommandBus.send_command("gamephase",["interact_failed"])
		"chose_action_target":
			context["mode"] = "chose_character"
			context.erase("actor")
			context.erase("action_limit")
			context.erase("action")
	limit_mode = false
	grid_drawer.show_limit = false
	return true

func _on_target_chosed():
	dispatch("chose")

func _on_target_canceled():	
	dispatch("return")
