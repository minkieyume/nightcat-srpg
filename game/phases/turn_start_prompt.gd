extends Phase

func _ready() -> void:
	# 配置转换到下一个阶段 (RestoreAP)
	var restore_ap = get_parent().get_node("RestoreAP")
	if restore_ap:
		transition["next"] = restore_ap

func _enter() -> void:
	# 显示回合开始提示UI
	var ui_scene = preload("res://system/ui/turn_start_prompt_menu.tscn").instantiate()
	get_tree().current_scene.add_child(ui_scene)
	ui_scene.show_prompt("新回合开始")
	# 等待提示结束后自动进入下阶段（可用信号或回调实现）
	ui_scene.connect("prompt_finished", Callable(self, "_on_prompt_finished"))

func _on_prompt_finished():
	# 这里应触发流程推进事件，如 dispatch("next") 或 emit_signal
	if transition.has("next"):
		dispatch("next")
