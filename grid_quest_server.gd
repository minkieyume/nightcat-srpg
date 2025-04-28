extends GridMapServer

func _quest_character(quester:Node,target:Vector2i):
	if quester.is_in_group("grid_quester"):
		for character in get_tree().get_nodes_in_group("character"):
			if grid_map.local_to_map(character.position) == target:
				quester.get_grid_result(character)
