extends Phase

func _ready() -> void:
	print("[TurnStartPrompt] _ready() 被调用")
	# 检查transition字典的内容
	if transition.is_empty():
		print("[TurnStartPrompt] 警告：transition字典为空！可能在编辑器中没有正确设置")
	else:
		print("[TurnStartPrompt] transition字典内容: ", transition)
		for key in transition.keys():
			print("[TurnStartPrompt] 转换: ", key, " -> ", transition[key])

func _enter() -> void:
	print("[TurnStartPrompt] 进入阶段 - 显示回合开始提示UI")
	print("[TurnStartPrompt] 当前父节点: ", get_parent())
	print("[TurnStartPrompt] 父节点类型: ", get_parent().get_class())

	# 显示回合开始提示UI
	var ui_scene = preload("res://system/ui/turn_start_prompt_menu.tscn").instantiate()
	get_tree().current_scene.add_child(ui_scene)
	ui_scene.show_prompt("新回合开始")
	# 等待提示结束后自动进入下阶段（可用信号或回调实现）
	ui_scene.connect("prompt_finished", Callable(self, "_on_prompt_finished"))

func _on_prompt_finished():
	print("[TurnStartPrompt] _on_prompt_finished() 被调用")
	print("[TurnStartPrompt] 检查transition字典: ", transition)
	print("[TurnStartPrompt] 当前是否激活: ", is_active())
	print("[TurnStartPrompt] 父节点状态机是否激活: ", get_parent().is_active() if get_parent() is LimboHSM else "不是LimboHSM")
	
	# 这里应触发流程推进事件，如 dispatch("next") 或 emit_signal
	if transition.has("next"):
		var target = transition["next"]
		print("[TurnStartPrompt] 找到next目标: ", target)
		print("[TurnStartPrompt] 目标类型: ", target.get_class() if target else "null")
		if target != null:
			print("[TurnStartPrompt] 目标节点路径: ", target.get_path())
		else:
			print("[TurnStartPrompt] 目标节点路径: null")
		print("[TurnStartPrompt] 调用dispatch('next')")
		
		# 检查转换是否真的被添加到状态机中
		var parent_hsm = get_parent()
		if parent_hsm is LimboHSM:
			print("[TurnStartPrompt] 父状态机转换数量: ", parent_hsm.get_children().size())
		
		var result = dispatch("next")
		print("[TurnStartPrompt] dispatch('next') 返回值: ", result)
		print("[TurnStartPrompt] dispatch调用后，当前是否还激活: ", is_active())
		
		# 检查目标是否被激活
		if target:
			print("[TurnStartPrompt] 目标节点是否激活: ", target.is_active())
	else:
		print("[TurnStartPrompt] 错误：transition字典中没有'next'键！")
		print("[TurnStartPrompt] 可用的键: ", transition.keys())
