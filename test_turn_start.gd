# 简单测试脚本 - 验证TurnStartPrompt功能
extends Node

func _ready():
	print("=== 测试TurnStartPrompt系统 ===")
	
	# 等待1秒让场景完全加载
	await get_tree().create_timer(1.0).timeout
	
	# 查找GamePhaseController
	var game_phase_controller = get_tree().current_scene.find_child("GamePhaseController", true, false)
	if game_phase_controller:
		print("找到GamePhaseController：", game_phase_controller.name)
		
		# 启动游戏阶段控制器
		game_phase_controller.start()
		print("已启动游戏阶段控制器")
	else:
		print("未找到GamePhaseController")

func _input(event):
	if event.is_action_pressed("ui_accept"):  # 按Enter键重新测试
		get_tree().reload_current_scene()
