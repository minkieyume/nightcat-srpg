class_name MovementServer
extends GridMapServer
## 处理角色在图块中的移动请求

var astar:AStarGrid2D

signal move_failed

func _ready() -> void:
	super()
	_init_astar()
	_set_tile_blocks()
	update_character_blocks()

func _init_astar() -> void:
	astar = AStarGrid2D.new()
	astar.region = Rect2i(Vector2i(0,0),tile_size)
	astar.set_default_compute_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	astar.set_default_estimate_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	astar.set_diagonal_mode(astar.DiagonalMode.DIAGONAL_MODE_NEVER)	
	astar.update()

## 批量设置图块障碍效果
func _set_tile_blocks() -> void:
	var quester = level_handler.get_grid_quester()
	var block_tiles = quester.quest_block_tiles()
	for tile in block_tiles:
		astar.set_point_solid(tile,true)
	astar.update()

## 更新角色自带的障碍效果
func update_character_blocks() -> void:
	var characters = level_handler.get_character_array()
	for character in characters:
		var tile = level_handler.get_character_position(character.id)
		astar.set_point_solid(tile,true)
	astar.update()

## 获取路径长度的格数
func get_path_length(start: Vector2i, target: Vector2i) -> int:
	if astar.is_point_solid(target):
		return 0
	var path = astar.get_id_path(start, target)
	# 修正：ap消耗应为实际格数（path.size()-1），最小为0
	return max(path.size() - 1, 0)

## 移动角色
func _move_character(cid:String,target:Vector2i):	
	var character = level_handler.get_character(cid)
	var start = grid_map.local_to_map(character.position)
	var path = get_move_path(start,target)
	if is_point_reachable(cid,target):
		await character.step_path(path,tile_size,grid_map)
		update_character_blocks()
	else:
		#print("failed")
		emit_signal("move_failed")

func get_move_path(start:Vector2i,end:Vector2i) -> Array:
	return astar.get_id_path(start,end)

## 坐标是否可达
func is_point_reachable(cid:String,target:Vector2i) -> bool:	
	var character = level_handler.get_character(cid)
	var start = grid_map.local_to_map(character.position)
	var path = get_move_path(start,target)
	if astar.is_point_solid(target):
		return false	
	if path.size() < 0:
		return false
	return true


# Note:坐标从0开始算，而非从1开始算。
## 接收移动角色指令。
func _on_command_recieved(command:StringName,args:Array):
	if command == "move_character":
		_move_character(args[0],args[1])
