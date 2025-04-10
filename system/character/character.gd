class_name Character
extends Area2D

@export var space_tilemap:TileMapLayer
@export var move_speed = 96

@onready var action_manager:ActionManager = $ActionManager
@onready var animation_player = $AnimationPlayer

#LimboHSM状态机插件
@onready var hsm: LimboHSM = $LimboHSM
@onready var idle_state: LimboState = $LimboHSM/IdleState
@onready var move_state: LimboState = $LimboHSM/MoveState

var astar:AStarGrid2D

var direction:Vector2i = Vector2i.DOWN:
	# 玩家朝向
	set(d):
		direction = d
		emit_signal("direction_changed",direction)
var move_path = []

signal started_move(target:Vector2i)
signal direction_changed(direct:Vector2i)

func _ready() -> void:
	_init_state_machine()
	_init_astar()
	act(&"action",Vector2i(2,2))
	emit_signal("started_move",Vector2i(10,10))

func _init_state_machine() -> void:
	hsm.add_transition(idle_state, move_state,"move_start")
	hsm.add_transition(move_state, idle_state,"move_stop")
	hsm.initialize(self)
	hsm.set_active(true)

func _init_astar() -> void:
	astar = AStarGrid2D.new()
	astar.region = Rect2i(Vector2i(0,0),space_tilemap.tile_set.tile_size)
	astar.set_default_compute_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	astar.set_default_estimate_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	astar.set_diagonal_mode(astar.DiagonalMode.DIAGONAL_MODE_NEVER)
	astar.update()

func change_direction(dir:Vector2i) -> bool:
	match dir:
		Vector2.DOWN:
			direction = dir
			return true
		Vector2.LEFT:
			direction = dir
			return true
		Vector2.RIGHT:
			direction = dir
			return true
		Vector2.UP:
			direction = dir
			return true
		_:
			return false
	
func act(id:StringName,target:Vector2i) -> bool:
	#玩家执行行动，成功返回true。
	return action_manager.execute_action(id,target)

func _on_started_move(target:Vector2i) -> void:
	var start = space_tilemap.local_to_map(position)
	move_path = astar.get_id_path(start,target)
	hsm.dispatch("move_start")
