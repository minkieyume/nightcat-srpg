extends LimboState

func _enter() -> void:
	agent.visible = false
	agent.remove_from_group("block")
	var movement = LevelHandler.get_movement_server()
	movement.remove_unit_blocks(func(u):return u.id == agent.id)
