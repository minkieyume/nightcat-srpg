extends Phase

func _enter() -> void:
	print("[PlayerTurn] 回合结束")
	dispatch("next")
