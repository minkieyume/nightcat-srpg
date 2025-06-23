extends Phase

func _enter() -> void:
	print("[PlayerTurn] 玩家阶段")
	dispatch("next")
