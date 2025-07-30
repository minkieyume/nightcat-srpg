extends LimboState

func _enter() -> void:
	agent.visible = true
	agent.add_to_group("block")
