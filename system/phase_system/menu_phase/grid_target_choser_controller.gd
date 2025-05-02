extends MenuPhase

var grid_drawer:GridDrawer

"""Transition：
&"character_chose" -> action_choser
&"action_target_chose" -> action_achiever
"""

"""上下文：
target:Vector2i 选中的目标，通常是一个坐标。
target_chose_event:StringName TargetChoser选中后触发的事件，决定接下来转换到哪个节点
chosed_action: ActionChoser选中的行动。
"""

func _ready() -> void:
	super()
	add_event_handler("chose",_chose)
	context["target_chose_event"] = &"character_chose"

func _setup() -> void:
	grid_drawer = level_handler.get_grid_drawer()

func _enter() -> void:
	super()
	grid_drawer.show_highlight = true

func _exit() -> void:
	super()
	grid_drawer.show_highlight = false

func _chose() -> bool:
	context["target"] = get_chosed_target()
	dispatch(context["target_chose_event"])
	return true

func update_target_position(new_pos:Vector2i):
	grid_drawer.highlight = new_pos

func get_chosed_target() -> Vector2i:
	return grid_drawer.highlight

func _return(cargo:Dictionary) -> bool:
	return true

func _on_target_chosed():
	dispatch("chose")

func _on_target_canceled():
	dispatch("_return")
