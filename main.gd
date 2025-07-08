extends Node

@onready var level = $Test001
@onready var game_phase_controller = $GamePhaseController
@onready var menu_manager = $CanvasLayer/MenuManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelHandler.level_init(level)
	game_phase_controller.start()
	menu_manager.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
