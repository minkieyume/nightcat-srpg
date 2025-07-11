class_name MovementServer
extends GridMapServer
## 处理角色在图块中的移动请求

var piercing_astar:AStarGrid2D
var astar:AStarGrid2D

func _on_level_ready():
	super()
	_init_astar()
	_init_piercing_astar()
	_set_tile_blocks()
	add_unit_blocks()

func _init_piercing_astar() -> void:
	piercing_astar = AStarGrid2D.new()
	piercing_astar.region = Rect2i(Vector2i(0,0),tile_size)
	piercing_astar.set_default_compute_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	piercing_astar.set_default_estimate_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	piercing_astar.set_diagonal_mode(astar.DiagonalMode.DIAGONAL_MODE_NEVER)	
	piercing_astar.update()

func _init_astar() -> void:
	astar = AStarGrid2D.new()
	astar.region = Rect2i(Vector2i(0,0),tile_size)
	astar.set_default_compute_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	astar.set_default_estimate_heuristic(astar.Heuristic.HEURISTIC_MANHATTAN)
	astar.set_diagonal_mode(astar.DiagonalMode.DIAGONAL_MODE_NEVER)	
	astar.update()

## 批量设置图块障碍效果
func _set_tile_blocks() -> void:
	var quester = LevelHandler.get_grid_quester()
	var block_tiles = quester.quest_block_tiles()
	for tile in block_tiles:
		set_tile_block(tile)
	astar.update()

## 移除所有单位自带的障碍效果
func remove_unit_blocks(filter:Callable = func(_x):return true) -> void:
	var units = LevelHandler.get_units().filter(filter)
	for unit in units:
		var tile = LevelHandler.get_unit_position(unit.id)
		set_tile_passable(tile)
	astar.update()

## 增加所有单位自带的障碍效果
func add_unit_blocks(filter:Callable = func(_x):return true) -> void:
	var units = LevelHandler.get_units().filter(filter)
	for unit in units:
		var tile = LevelHandler.get_unit_position(unit.id)
		set_tile_block(tile)
	astar.update()

func set_tile_block(tile:Vector2i):
	if !astar.is_point_solid(tile):
		astar.set_point_solid(tile,true)

func set_tile_passable(tile:Vector2i):
	if astar.is_point_solid(tile):
		astar.set_point_solid(tile,false)

## 获取路径长度的格数
func get_path_length(start: Vector2i, target: Vector2i) -> int:
	if astar.is_point_solid(target):
		return 0
	var path = get_move_path(start,target)
	# 修正：ap消耗应为实际格数（path.size()-1），最小为0
	return max(path.size() - 1, 0)

## 移动单位
func move_unit(cid:String,target:Vector2i) -> bool:
	var unit = LevelHandler.get_unit(cid)
	var drawer = LevelHandler.get_grid_drawer()	

	# 移除单位的视野显示
	if unit is Character:
		unit.hide_sight_view()
	if unit.is_in_group("enemy"):
		drawer.update()
	
	#单位行动逻辑
	var start = grid_map.local_to_map(unit.position)	
	if is_point_reachable(cid,target):
		var path = get_move_path(start,target)
		set_tile_passable(start)
		await unit.step_path(path,tile_size,grid_map)

		# 更新全体单位的疑惑对象列表
		for character in LevelHandler.get_characters():
			# 如果开始移动时角色在不在单位的视野范围内
			# 则将角色存入疑惑列表。
			var cpos = LevelHandler.get_unit_position(character.id)
			var quester = LevelHandler.get_grid_quester()
			if !quester.is_in_sight(start,cpos,character.sector):			
				character.quest_question_units()
	else:		
		return false
	remove_unit_blocks(func(u:Unit):return u.id == cid)
	add_unit_blocks(func(u:Unit):return u.id == cid)

	# 更新敌人的视野显示
	if unit.is_in_group("enemy"):
		unit.show_sight_view()
		drawer.update()
	return true

## 获取移动的路径
func get_move_path(start:Vector2i,end:Vector2i) -> Array:
	return astar.get_id_path(start,end)

## 单位坐标是否可达
func is_point_reachable(cid:String,target:Vector2i) -> bool:
	var start = LevelHandler.get_unit_position(cid)
	var path = get_move_path(start,target)
	if path.is_empty():
		return false
	if astar.is_point_solid(target):
		return false
	return true


# Note:坐标从0开始算，而非从1开始算。
## 接收移动角色指令。
func _on_command_recieved(command:StringName,args:Array):
	if command == "move_unit":
		move_unit(args[0],args[1])
