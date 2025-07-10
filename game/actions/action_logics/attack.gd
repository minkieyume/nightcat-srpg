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
	requester.change_direction(dir)	
	requester.update_sight_face(dir)
	character.apply_damage(1)
	
