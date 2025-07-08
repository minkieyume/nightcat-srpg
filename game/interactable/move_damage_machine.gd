extends Interactable

func before_interact(_character:String,_ctx:Dictionary):
	CommandBus.send_command("gamephase",["wait"])
	CommandBus.send_command("gamephase",["setcargo","mode","interact"])
	CommandBus.send_command("menu",["setcargo","mode","chose_interactable_target"])
	CommandBus.send_command("menu",["action"])

func interact(_character:String,ctx:Dictionary):
	CommandBus.send_command("gamephase",["wait"])
	var target:Vector2i = ctx["target"]	
	CommandBus.send_command("move_unit",[id,target])
	await path_end
	var quester = LevelHandler.get_grid_quester()
	var pos = quester.quest_tile(position)
	var damage_range = quester.quest_tiles_in_radius(pos,1)
	if !damage_range.is_empty():
		var enemies = quester.quest_character_in_area(damage_range)
		enemies = enemies.filter(func(e:Character):return e.is_in_group("enemy"))
		for enemy in enemies:
			enemy.apply_damage(1)
	CommandBus.send_command("gamephase",["setcargo","mode","end_interact"])
	CommandBus.send_command("gamephase",["interact_sucess"])
	call_deferred("end")
	
