extends Node

@onready var game_phase_controller = $GamePhaseController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("[Main] 启用 GamePhaseController")
	game_phase_controller.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
