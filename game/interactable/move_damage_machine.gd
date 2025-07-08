extends Interactable

func before_interact(_character:String,_ctx:Dictionary):
	LevelHandler.send_command("chose_target",[])

func interact(_character:String,ctx:Dictionary):
	var target:Vector2i = ctx["target"]
	var movement = LevelHandler.get_movement_server()	
	movement._move_interactable(id,target)	
	await path_end
	var quester = LevelHandler.get_grid_quester()
	var pos = quester.quest_tile(position)
	var damage_range = quester.quest_tiles_in_radius(pos,1)
	if !damage_range.is_empty():
		var enemies = quester.quest_character_in_area(damage_range)
		enemies = enemies.filter(func(e:Character):return e.is_in_group("enemy"))
		for enemy in enemies:
			enemy.apply_damage(1)
	emit_signal("finished")
