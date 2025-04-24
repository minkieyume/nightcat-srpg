extends GridMapServer
# 处理角色在网格图块中的移动逻辑

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

func _move_character(character:Character,target:Vector2i):
	var path = []
	var start = grid_map.local_to_map(character.position)
	if astar.is_point_solid(target):
		return
	path = astar.get_id_path(start,target)
	print(path)
	for point in path:
		await character.step(point - start,tile_size)
		start = grid_map.local_to_map(character.position)

# Note:坐标从0开始算，而非从1开始算。
func _on_charactermove_requested(character:Character,target:Vector2i):
	_move_character(character,target)
