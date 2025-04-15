extends Control

@export var grid_drawer:GridDrawer

var chosing:bool = true # 正在选择

signal target_chosed
signal target_canceled

func _ready() -> void:
	grab_focus()

func _gui_input(event) -> void:
	if event.is_action_pressed("ui_accept") and chosing:
		chosing = false
		emit_signal("target_chosed")
	if event.is_action_pressed("ui_cancel") and !chosing:
		chosing = true
		emit_signal("target_canceled")
	if chosing:
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

func _on_target_chosed():
	print("行动了")
	grid_drawer.show_highlight = false

func _on_target_canceled():
	print("取消了")
	grid_drawer.show_highlight = true
