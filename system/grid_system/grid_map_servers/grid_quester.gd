class_name GridQuester
## 从地图中查询信息并返回
extends GridMapServer

## 在给定位置搜寻匹配的角色，返回角色id，如果没有则返回空字符串
func quest_character(target:Vector2i) -> String:
	var character_list = LevelHandler.get_characters()	
	for character in character_list:		
		if grid_map.local_to_map(character.position) == target:
			return character.id
	return ""

## 在给定位置搜寻单位，返回单位id，如果没有则返回空字符串
func quest_unit(target:Vector2i) -> String:
	var units = LevelHandler.get_units()
	for unit in units:
		if grid_map.local_to_map(unit.position) == target:
			return unit.id
	return ""

## 获取图块坐标。
func quest_tile_position(target:Vector2i) -> Vector2:	
	return grid_map.map_to_local(target)
	
## 获取图块中点坐标。
func quest_tile_center(target:Vector2i) -> Vector2:
	var tile_pos = grid_map.map_to_local(target)	
	return tile_pos+Vector2(tile_size/2)

## 获取坐标对应的图块
func quest_tile(target:Vector2) -> Vector2i:
	return grid_map.local_to_map(target)

func quest_block_tiles() -> Array:
	var tiles = grid_map.get_used_cells()
	return tiles.filter(grid_map.is_cell_block)

func quest_passable_tiles() -> Array:
	var tiles = grid_map.get_used_cells()
	return tiles.filter(grid_map.is_cell_passable)

func is_tile_passable(pos:Vector2i) -> bool:	
	return grid_map.is_cell_passable(pos)


## 判断目标是否在圆形范围内
func is_in_radius(origin: Vector2i, target: Vector2i, radius: int) -> bool:
	return origin.distance_to(target) <= radius

## 获取圆形范围内所有格子
func quest_tiles_in_radius(origin: Vector2i, radius: int) -> Array:
	var result = []
	for x in range(-radius, radius+1):
		for y in range(-radius, radius+1):
			var pos = origin + Vector2i(x, y)
			if is_in_radius(origin, pos, radius):
				result.append(pos)
	return result

## 判断目标是否在扇形范围内
func is_in_sector(origin: Vector2i, target: Vector2i, direction: Vector2i, angle: float, radius: int) -> bool:
	if not is_in_radius(origin, target, radius):
		return false
	var dir_vec = target - origin
	if dir_vec.length() == 0:
		return true
	dir_vec = dir_vec / dir_vec.length()
	var main_dir = direction
	if main_dir.length() == 0:
		return false
	main_dir = main_dir / main_dir.length()
	var dot = dir_vec.dot(main_dir)
	var theta = acos(dot)
	return theta <= deg_to_rad(angle) * 0.5

## 获取扇形范围内所有格子
func quest_tiles_in_sector(origin: Vector2i, direction: Vector2i, angle: float, radius: int) -> Array[Vector2i]:
	var result = []
	for pos in quest_tiles_in_radius(origin, radius):
		if is_in_sector(origin, pos, direction, angle, radius):
			result.append(pos)
	return result

# 判断两点间是否有视线遮挡
func has_line_of_sight(origin: Vector2i, target: Vector2i) -> bool:
	# TODO: 结合TileMap障碍属性实现Bresenham算法	
	for tile in Geometry2D.bresenham_line(origin,target):
		if grid_map.is_cell_block(tile):
			return true
	return false

# 获取区域内所有角色
func quest_character_in_area(area: Array) -> Array:
	var result = []
	for character in LevelHandler.get_characters():
		var c_pos = LevelHandler.get_unit_position(character.id)
		if c_pos in area:
			result.append(character)
	return result

# 获取区域内所有单位，按指定filter过滤
func get_unit_in_area(area: Array,filter:Callable=func(_u:Unit):return true) \
	-> Array:
	var result = []
	var units = LevelHandler.get_units()
	for unit in units.filter(filter):
		var c_pos = LevelHandler.get_interactable_position(unit)
		if c_pos in area:
			result.append(unit)
	return result

func quest_unit_nearst_nearby_tile(origin:Vector2i,uid:String) -> Vector2i:	
	var target_pos = LevelHandler.get_unit_position(uid)
	var min_pos = target_pos
	var min_dist = INF
	for dir in [Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.UP]:
		var pos = min_pos + dir
		var dist = origin.distance_to(pos)
		if dist < min_dist:
			min_dist = dist
			target_pos = pos
	return target_pos

