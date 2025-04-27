extends MenuState

@export var grid_drawer:GridDrawer

"""Transition：
"character_chose" -> action_choser
"""

"""上下文：
target:Vector2i 选中的目标，通常是一个坐标。
target_chose_event:StringName TargetChoser选中后触发的事件，决定接下来转换到哪个节点
"""

signal target_chosed
signal target_canceled

func _ready() -> void:
	super()
	add_event_handler("chose",_chose)
	context["target_chose_event"] = &"character_chose"

func _enter() -> void:
	super()
	grid_drawer.show_highlight = true

func _exit() -> void:
	super()
	grid_drawer.show_highlight = false

func _gui_input(event) -> void:
	if event.is_action_pressed("ui_accept"):
		emit_signal("target_chosed")
	elif event.is_action_pressed("ui_cancel"):
		emit_signal("target_canceled")
	else:
		grid_drawer.highlight+= _get_input_direction()

func _get_input_direction() -> Vector2i:
	var dir:=\
		Input.get_vector("ui_left","ui_right","ui_up","ui_down",0.0)
	if abs(dir.x) > abs(dir.y):
		return Vector2i(sign(dir.x), 0)
	elif abs(dir.y) > 0:
		return Vector2i(0, sign(dir.y))
	return Vector2i.ZERO

func get_chosed_target() -> Vector2i:
	return grid_drawer.highlight

func _return(cargo:Dictionary) -> bool:
	return true

func _chose() -> bool:
	print("行动了")
	context["target"] = get_chosed_target()
	dispatch(context["target_chose_event"])
	return true

func _on_target_chosed():
	dispatch("chose")

func _on_target_canceled():
	dispatch("_return")
	
