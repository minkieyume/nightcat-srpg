extends GridMapServer
# 处理角色在图块中的移动请求

var astar:AStarGrid2D

func _ready() -> void:
	super()
	_init_astar()

func _init_astar() -> void:
	astar = AStarGrid2D.new()
	astar.region = Rect2i(Vector2i(0,0),tile_size)
	astar.set_default_compute_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	astar.set_default_estimate_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	astar.set_diagonal_mode(astar.DiagonalMode.DIAGONAL_MODE_NEVER)
	astar.update()

func _move_character(cid:int,target:Vector2i):
	var path = []
	var character = level_handler.get_character(cid)
	var start = grid_map.local_to_map(character.position)
	if astar.is_point_solid(target):
		return
	path = astar.get_id_path(start,target)
	character.step_path(path,tile_size,grid_map)

# Note:坐标从0开始算，而非从1开始算。
func _on_command_recieved(command:StringName,args:Array):
	if command == "move_character":
		_move_character(args[0],args[1])
