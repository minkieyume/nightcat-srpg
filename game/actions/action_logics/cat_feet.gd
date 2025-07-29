extends ActionLogic

# 猫步：做好躲避敌人攻击的准备。
func execute(action:Action):
	var player = LevelHandler.get_unit(action.requester)
	if player.is_in_group("cat_feet"):
		player.cat_feet = true
