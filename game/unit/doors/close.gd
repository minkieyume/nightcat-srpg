extends LimboState

func _enter() -> void:
	agent.visible = true
	agent.add_to_group("block")
	var movement = LevelHandler.get_movement_server()
	movement.add_unit_blocks(func(u):return u.id == agent.id)
