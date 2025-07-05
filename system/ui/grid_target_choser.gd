extends PhaseMenu

signal target_chosed
signal target_canceled

func _ready() -> void:
	super()
	grab_focus()
	if phase is GridTargetChoserController:
		target_chosed.connect(phase._on_target_chosed)
		target_canceled.connect(phase._on_target_canceled)

func _gui_input(event) -> void:
	if event.is_action_pressed("ui_accept"):
		emit_signal("target_chosed")
	elif event.is_action_pressed("ui_cancel"):
		emit_signal("target_canceled")
	else:
		var new_pos = phase.get_chosed_target()+_get_input_direction()
		phase.update_target_position(new_pos)

func _get_input_direction() -> Vector2i:
	var dir:=\
		Input.get_vector("ui_left","ui_right","ui_up","ui_down",0.0)
	if abs(dir.x) > abs(dir.y):
		return Vector2i(sign(dir.x), 0)
	elif abs(dir.y) > 0:
		return Vector2i(0, sign(dir.y))
	return Vector2i.ZERO
