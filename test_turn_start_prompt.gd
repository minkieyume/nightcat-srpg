extends SceneTree
# 简单的测试脚本来验证 TurnStartPrompt 是否工作

func _initialize():
	print("=== TurnStartPrompt 测试开始 ===")
	
	# 模拟主场景
	var main_scene = Node.new()
	main_scene.name = "Main"
	current_scene = main_scene
	
	# 创建 GamePhaseController
	var controller_scene = preload("res://game/managers/game_phase_controller.tscn")
	var controller = controller_scene.instantiate()
	main_scene.add_child(controller)
	
	# 等待一帧让节点完全初始化
	await process_frame
	
	# 启动控制器
	print("启动 GamePhaseController...")
	controller.start()
	
	# 等待5秒观察结果，然后退出
	await create_timer(5.0).timeout
	
	print("=== 测试结束 ===")
	quit()
