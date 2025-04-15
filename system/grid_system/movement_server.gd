extends Node2D
# 处理角色在网格图块中的移动逻辑

@export var grid_map:TileMapLayer

var astar:AStarGrid2D

var tile_size:Vector2i

func _ready() -> void:
	tile_size = grid_map.tile_set.tile_size
	_init_astar()

func _init_astar() -> void:
	astar = AStarGrid2D.new()
	astar.region = Rect2i(Vector2i(0,0),tile_size)
	astar.set_default_compute_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	astar.set_default_estimate_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	astar.set_diagonal_mode(astar.DiagonalMode.DIAGONAL_MODE_NEVER)
	astar.update()

# BUG：角色实际移动的位置总是比输入的位置多一格
func _move_character(character:Character,target:Vector2i):
	var path = []
	var start = grid_map.local_to_map(character.position)
	if astar.is_point_solid(target):
		return
	path = astar.get_id_path(start,target)
	for point in path:
		await character.step(point - start,tile_size)
		start = grid_map.local_to_map(character.position)

func _on_charactermove_requested(character:Character,target:Vector2i):
	_move_character(character,target)
