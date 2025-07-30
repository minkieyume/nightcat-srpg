extends LimboState

func _enter() -> void:
	agent.visible = false
	agent.remove_from_group("block")
