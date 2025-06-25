extends Phase

func _enter() -> void:
	print("[EnemyTurn] 敌人回合")
	dispatch("next")
