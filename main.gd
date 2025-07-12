extends Node

@onready var mpc = $MultiPlayCore
@onready var game_phase_controller = $GamePhaseController
@onready var menu_manager = $CanvasLayer/MenuManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelHandler.level_ready.connect(_on_handler_level_load)
	# multiplayer.peer_connected.connect(_on_peer_connected)

func _on_handler_level_load() -> void:
	menu_manager.initialize(self)	
	menu_manager.start()
	if !MultiCat.is_online():
		_init_gamephase_controller()

func _init_gamephase_controller():
	game_phase_controller.initialize(self)
	game_phase_controller.start()

func _on_multi_play_core_player_connected(player:MPPlayer) -> void:
	if is_multiplayer_authority():
		_init_gamephase_controller()
