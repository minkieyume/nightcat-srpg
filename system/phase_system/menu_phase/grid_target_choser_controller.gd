class_name GridTargetChoserController
extends MenuPhase
## 图块选择器控件
## 转换表：
## &"character_chose" -> action_choser
## &"action_target_chose" -> action_achiever
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

func _setup() -> void:
	grid_drawer = level_handler.get_grid_drawer()

func _enter() -> void:
	super()
	grid_drawer.show_highlight = true
	if context["target_chose_event"] == "action_target_chose":
		if context.has("action_limit"):
			grid_drawer.limit_array = context["action_limit"]
			grid_drawer.show_limit = true		
			limit_mode = true
	

func _exit() -> void:
	super()
	grid_drawer.show_highlight = false
	if limit_mode:
		limit_mode = false
		grid_drawer.show_limit = false

func _chose() -> bool:
	context["target"] = get_chosed_target()
	context.erase("action_limit")
	dispatch(context["target_chose_event"])	
	return true

func update_target_position(new_pos:Vector2i):
	grid_drawer.highlight = new_pos

func get_chosed_target() -> Vector2i:
	return grid_drawer.highlight

func _return() -> bool:
	if context["target_chose_event"] == "action_target_chose":
		context["target_chose_event"] = "character_chose"
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
