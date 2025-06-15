extends Phase

@onready var phase_controller = $PhaseController

func _enter() -> void:
	print("[PrepareTurn] _enter() 被调用!")
	print("[PrepareTurn] 即将启动子PhaseController")
	phase_controller.start()
	print("[PrepareTurn] 子PhaseController启动完成")
	
func _update(_delta: float) -> void:
	pass
