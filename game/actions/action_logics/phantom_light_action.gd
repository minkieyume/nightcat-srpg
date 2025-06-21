extends ActionLogic

# 幻影灯光：生成幻影引导敌人偏移
func execute(character:int, target:Vector2i, handler:LevelHandler) -> bool:
	# 生成幻影对象，吸引敌人
	var enemies = handler.get_enemy_list()
	for enemy in enemies:
		if enemy.can_be_lured():
			enemy.set_lure_target(target)
	return true
