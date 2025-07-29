extends ActionLogic

## 行动的预检查，用于检查行动能否执行
func precheck(action:Action) -> bool:
	var quester = LevelHandler.get_grid_quester()
	if !action.target:
		return false
	var cid = quester.quest_character(action.target)
	var character = LevelHandler.get_character(cid)
	if character:
		return true
	else:
		return false

func execute(action:Action):
	var quester = LevelHandler.get_grid_quester()
	var cid = quester.quest_character(action.target)
	var requester = LevelHandler.get_unit(action.requester)
	var character = LevelHandler.get_unit(cid)
	var origin = LevelHandler.get_unit_position(action.requester)
	var dir = quester.quest_related_direction(origin,action.target)
	var args = action.args
	requester.change_direction(dir)
	requester.update_sight_face(dir)
	
	## 临时策略，将小琪的猫步判定逻辑写在攻击行动。
	var grid_quester = LevelHandler.get_grid_quester()
	var unit_id = grid_quester.quest_unit(action.target)
	var unit = LevelHandler.get_character(unit_id)
	print("cat_feet_attack")
	if unit and LevelHandler.is_unit_in_group(unit.id,"cat_feet") and unit.cat_feet:
		var qte = MenuHandler.get_qte()
		CommandBus.send_command("menu",["setcargo","mode","cat_feet"])
		CommandBus.send_command("menu",["setcargo","_action",action])
		CommandBus.send_command("menu",["setcargo","part",unit.part])
		CommandBus.send_command("menu",["qte"])
		await qte.qte_finish
		if action.ctx.has("qte_result") and action.ctx["qte_result"] > 0:
			var target_choser:GridTargetChoserController = MenuHandler.get_grid_target_choser()
			## FEATURE：我觉得，给目标选择器在有限制数组的时候，加上实际将target限制在范围内的机制很有必要
			## 这样有利于在任何地方灵活调用并获取限制后的目标。
			CommandBus.send_command("menu",["setcargo","mode","cat_feet"])
			CommandBus.send_command("menu",["setcargo","_action",action])
			CommandBus.send_command("menu",["chose_target"])
			await target_choser.grid_chosed
			if action.ctx.has("target"):
				var movement = LevelHandler.get_movement_server()
				movement.rpc("move_unit",unit,action.ctx["target"])
				await LevelHandler.get_unit(unit).path_end
		else:
			# 闪避失败受到的伤害
			if is_apply_damage(unit.part):
				character.rpc("apply_damage")
				character.apply_damage(args["damage"])
	else:
		# 对通常的敌人应用伤害
		if is_apply_damage(unit.part):
			character.rpc("apply_damage")
			character.apply_damage(args["damage"])
	
func is_apply_damage(part:String) -> bool:
	if MultiCat.is_online():
		var agents = MultiCat.get_agents()
		var player_id = MultiCat.multiplayer.get_unique_id()
		var agen = agents["%d"%player_id]
		if agen.part == part:
			return true
		return false
	else:
		return true
