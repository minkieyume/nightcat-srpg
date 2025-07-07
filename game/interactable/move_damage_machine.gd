extends Interactable
## Interactable的接口类
## 要实现该类，只需要实现该类的全部方法，并添加interactable的组即可。

func before_interact(character:String,handler:LevelHandler):
	handler.send_command("chose_target",[])

func interact(character:String,handler:LevelHandler,ctx:Dictionary):
	var target:Vector2i = ctx["target"]
	var movement = handler.get_movement_server()	
	movement._move_interactable(id,target)	
	await path_end
	var quester = handler.get_grid_quester()
	var pos = quester.quest_tile(position)
	var damage_range = quester.quest_tiles_in_radius(pos,2)
	var enemies = quester.quest_character_in_area(damage_range)
	enemies = enemies.filter(func(e:Character):return e.is_in_group("enemy"))
	for enemy in enemies:
		enemy.apply_damage(1)
	emit_signal("finished")
