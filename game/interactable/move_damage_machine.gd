extends Interactable

func before_interact(_character:String,_ctx:Dictionary):
	CommandBus.server_local_command("gamephase",["wait"])
	CommandBus.server_local_command("gamephase",["setcargo","mode","interact"])
	CommandBus.server_local_command("menu",["setcargo","mode","chose_interactable_target"])
	CommandBus.server_local_command("menu",["chose_target"])

func precheck(_character:String,ctx:Dictionary) -> bool:
	var target:Vector2i = ctx["target"]
	var movement = LevelHandler.get_movement_server()
	if movement.is_point_reachable(id,target):
		return true
	else:
		return false	

## BUG：要重构interactable类来修复interactable的选中互动目标失败无法反馈的bug
func interact(_character:String,ctx:Dictionary):
	CommandBus.server_local_command("gamephase",["wait"])
	var target:Vector2i = ctx["target"]
	var movement = LevelHandler.get_movement_server()
	var move_result = await movement.move_unit(id,target)
	if !move_result:
		CommandBus.server_local_command("gamephase",["interact_failed"])
		call_deferred("end")
		return
	var quester = LevelHandler.get_grid_quester()
	var pos = quester.quest_tile(position)
	var damage_range = quester.quest_tiles_in_radius(pos,1)
	if !damage_range.is_empty():
		var enemies = quester.quest_character_in_area(damage_range)
		enemies = enemies.filter(func(e:Character):return e.is_in_group("enemy"))
		for enemy in enemies:
			enemy.apply_damage(1)
	CommandBus.server_local_command("gamephase",["setcargo","mode","end_interact"])
	CommandBus.server_local_command("gamephase",["interact_sucess"])
	call_deferred("end")
