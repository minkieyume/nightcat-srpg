extends Phase

func _enter() -> void:
	print("[EnemyTurn] 回合结束")
	dispatch("next")
