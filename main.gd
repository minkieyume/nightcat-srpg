extends Node

@onready var mpc = $MultiPlayCore
@onready var game_phase_controller = $GamePhaseController
@onready var menu_manager = $CanvasLayer/MenuManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelHandler.level_ready.connect(_on_handler_level_load)
	# multiplayer.peer_connected.connect(_on_peer_connected)

func _on_handler_level_load() -> void:
	if MultiCat.should_sync():
		if is_multiplayer_authority():
			_init_gamephase_controller()
	else:
			_init_gamephase_controller()
	menu_manager.initialize(self)	
	menu_manager.start()

func _init_gamephase_controller():
	game_phase_controller.initialize(self)
	game_phase_controller.start()

# func _on_peer_connected(id:int):	
# 	if is_multiplayer_authority():
# 		var ctx = game_phase_controller.get_context()
# 		var state_list = game_phase_controller.get_active_state_list()
# 		game_phase_controller.rpc_id(id,"queue_sync",ctx,state_list)
