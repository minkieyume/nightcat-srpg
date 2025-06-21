extends Phase

func _ready() -> void:
	print("[TurnStartPrompt] _ready() 被调用")

func _enter() -> void:
	# 显示回合开始提示UI
	var ui_scene = preload("res://system/ui/turn_start_prompt_menu.tscn").instantiate()
	get_tree().current_scene.add_child(ui_scene)
	ui_scene.show_prompt("新回合开始")
	# 等待提示结束后自动进入下阶段（可用信号或回调实现）
	ui_scene.connect("prompt_finished", Callable(self, "_on_prompt_finished"))

func _on_prompt_finished():
	var target = transition["next"]
	
	var parent_hsm = get_parent()
	var result = dispatch("next")
