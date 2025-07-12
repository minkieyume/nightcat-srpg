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

@export var default_mode = "choase_character"

func _ready() -> void:
	super()
	add_event_handler("chose",_chose)

func _enter() -> void:
	super()
	grid_drawer = LevelHandler.get_grid_drawer()
	grid_drawer.show_highlight = true
	grid_drawer.focus_highlight()
	match context["mode"]:
		"chose_action_target":
			var limit_array = context["limit_array"]
			grid_drawer.limit_array = limit_array
			grid_drawer.show_limit = true
			limit_mode = true
	grid_drawer.update()

func _exit() -> void:
	super()	
	grid_drawer.show_highlight = false
	if limit_mode:
		limit_mode = false
		grid_drawer.show_limit = false
	grid_drawer.update()
	

func _chose() -> bool:
	var target = get_chosed_target()
	context["target"] = target
	match context["mode"]:
		"chose_character":
			if !update_actor():
				print("[GridChoser] 选中目标不是角色，请重新选择")
				return true
			if !is_character_in_part():
				return true
			CommandBus.send_command("gamephase",["setcargo","actor",context["actor"]])
			CommandBus.send_command("gamephase",["setcargo","mode","chose_action"])
			dispatch("character_chose")
		"chose_action_target":
			context["action"].set_target(context["target"])			
			CommandBus.send_command("gamephase",["setcargo","action",context["action"]])
			context.erase("target")
			dispatch("action_target_chose")
		"chose_interactable_target":
			CommandBus.send_command("gamephase",["setcargo","target",context["target"]])
			CommandBus.send_command("gamephase",["interact_sucess"])
			context.erase("target")
			dispatch("interactable_target_chose")
	return true

func update_actor() -> bool:
	var grid_quester = LevelHandler.get_grid_quester()
	var actor = grid_quester.quest_character(context["target"])
	if actor != "":
		context["actor"] = actor
		var camera = LevelHandler.get_camera()		
		camera.set_follow_target(LevelHandler.get_character(actor))
		return true
	else:
		return false

func is_character_in_part():
	var character = LevelHandler.get_character(context["actor"])
	if character.part == context["part"]:
		return true
	else:
		print("[GridTargetChoser] 你没有该角色的控制权")		
		return false

func update_target_position(new_pos:Vector2i):
	grid_drawer.update_highlight(new_pos)
	grid_drawer.update()

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
			context.erase("action")
			CommandBus.cat_send_command("gamephase",["back"])
	limit_mode = false
	grid_drawer.show_limit = false
	grid_drawer.update()
	return true

func _on_target_chosed():
	dispatch("chose")

func _on_target_canceled():	
	dispatch("return")
