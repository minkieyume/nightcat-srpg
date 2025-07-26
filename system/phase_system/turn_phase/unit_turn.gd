extends Phase

func _enter() -> void:
	super()
	print("[Unit Turn] 运行所有Unit的回合开始操作")
	var units = LevelHandler.get_units()
	for unit in units:
		if unit.has_method("turn"):
			if MultiCat.is_online():
				if is_multiplayer_authority():
					unit.rpc("turn")
			unit.turn()
	call_deferred("dispatch","next")
