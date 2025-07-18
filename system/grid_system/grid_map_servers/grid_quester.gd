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

## 判断目标是否在扇形内
func is_in_sector(origin:Vector2i,target:Vector2i,sector:TiledSector2D) -> bool:
	if is_in_radius(origin,target,sector.radius):
		var o = Vector2(origin)
		var t = Vector2(target)
		var facing = Vector2(sector.face).normalized()
		var dir = (t - o).normalized()
		var angle = rad_to_deg(facing.angle_to(dir))
		return abs(angle) <= sector.angle / 2.0
	return false

## 获取扇形内的全部图块
func quest_tiles_in_sector(origin:Vector2i,sector:TiledSector2D) -> Array:
	var result = quest_tiles_in_radius(origin,sector.radius)
	return result.filter(func(tile):return is_in_sector(origin,tile,sector))

## 判断目标是否处于视野内
func is_in_sight(origin:Vector2i,target:Vector2i,sector:TiledSector2D) -> bool:
	if is_in_sector(origin,target,sector):
		if !has_line_of_sight(origin,target):
			return true
	return false

## 获取视野内的全部图块
func quest_tiles_in_sight(origin:Vector2i,sector:TiledSector2D) -> Array:
	var result = quest_tiles_in_sector(origin,sector)
	return result.filter(func(tile):return !has_line_of_sight(origin,tile))


# 判断两点间是否有视线遮挡
func has_line_of_sight(origin: Vector2i, target: Vector2i) -> bool:
	# TODO: 结合TileMap障碍属性实现Bresenham算法	
	for tile in Geometry2D.bresenham_line(origin,target):
		if grid_map.is_cell_block(tile):
			return true
	return false

## 获取区域内所有角色
func quest_character_in_area(area: Array) -> Array:
	var result = []
	for character in LevelHandler.get_characters():
		var c_pos = LevelHandler.get_unit_position(character.id)
		if c_pos in area:
			result.append(character)
	return result

func quest_block_tiles_in_area(area:Array) -> Array:
	return area.filter(grid_map.is_cell_block)

func quest_passable_tiles_in_area(area:Array) -> Array:
	return area.filter(grid_map.is_cell_passable)

## 获取target相对于orgin的方向。
func quest_related_direction(origin:Vector2i,target:Vector2i) -> Vector2i:
	var dir = Vector2(origin).direction_to(Vector2(target))	
	return Vector2i(round(dir))

## 获取区域内所有单位，按指定filter过滤
func quest_unit_in_area(area: Array,filter:Callable=func(_u:Unit):return true) \
	-> Array:
	var result = []
	var units = LevelHandler.get_units()
	for unit in units.filter(filter):
		var c_pos = LevelHandler.get_interactable_position(unit)
		if c_pos in area:
			result.append(unit)
	return result

## 从给定组中获取距离某个点最近的单位
func quest_nearst_unit(origin:Vector2i,units:Array[Unit]) -> Unit:
	var distance = INF
	var nearst_unit = units[0]
	for unit in units:
		var d = origin.distance_to(LevelHandler.get_unit(unit.id))
		if  d < distance:
			distance = d
			nearst_unit = unit
	return nearst_unit

func quest_tiles_nearby_unit(unit:String) -> Array:
	var unit_pos = LevelHandler.get_unit_position(unit)	
	return [Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.UP].map(func(x):return x+unit_pos)

## 获取与unit保持给定相对距离的图块，默认采用欧几里得距离算法。
func quest_tiles_distance_unit(unit:String,distance:int) -> Array:
	var origin = LevelHandler.get_unit_position(unit)
	var radius_tiles = quest_tiles_in_radius(origin,distance)
	var distance_tiles = radius_tiles.filter(func(t):return t.distance_to(origin)>=distance)
	return distance_tiles

## 获取与unit保持给定相对曼哈顿距离的图块，对于按步数计算很有用。
func quest_tiles_distance_unit_manhattan(unit:String,distance:int) -> Array:
	var origin = LevelHandler.get_unit_position(unit)
	var radius_tiles = quest_tiles_in_radius(origin,distance)
	var distance_tiles = radius_tiles.filter(func(t):return is_tile_manhattan_distance_bigger(origin,t,distance))
	return distance_tiles

func is_tile_manhattan_distance_bigger(origin:Vector2i,tile:Vector2i,distance:int) -> bool:
	var delta = tile - origin
	var manhattan = abs(delta.x) + abs(delta.y)
	return manhattan == distance

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
