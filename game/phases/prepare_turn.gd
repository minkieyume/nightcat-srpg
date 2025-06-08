extends Phase

@onready var phase_controller = $PhaseController

func _enter() -> void:
	# PhaseController 会在初始化时自动启动第一个子状态，但需要手动启动
	phase_controller.start()
	
func _update(_delta: float) -> void:
	pass
