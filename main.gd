extends Node

@onready var mpc = $MultiPlayCore
@onready var game_phase_controller = $GamePhaseController
@onready var menu_manager = $CanvasLayer/MenuManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelHandler.level_ready.connect(_on_handler_level_load)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_handler_level_load() -> void:	
	#game_phase_controller.initialize(self)
	#game_phase_controller.start()
	menu_manager.initialize(self)	
	menu_manager.start()	
