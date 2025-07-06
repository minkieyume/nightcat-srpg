class_name GridMapLayer
extends TileMapLayer
## 访问图块数据和地形的类

## 地形类型枚举，方便查阅
enum Terrain {
	NORMAL = 0,
	BLOCK = 1,
}

const TERRAIN_TYPES = [Terrain.NORMAL,Terrain.BLOCK]

## 获取格子类型，未设置则返回Terrain.NORMAL
func get_cell_type(pos: Vector2i) -> int:
	if tile_set.has_custom_data_layer_by_name("terrain_type"):		
		var tile_data = get_cell_tile_data(pos)
		var type = tile_data.get_custom_data("terrain_type")
		if type in TERRAIN_TYPES:
			return type
	return Terrain.NORMAL

## 是否可通行
func is_cell_passable(pos: Vector2i) -> bool:
	var t = get_cell_type(pos)
	return t in [Terrain.NORMAL]

## 是否为障碍
func is_cell_block(pos: Vector2i) -> bool:
	return get_cell_type(pos) == Terrain.BLOCK

## 下面是待重构的方法，建议移到grid_map_quester：

# 判断目标是否在圆形范围内
func is_in_radius(origin: Vector2i, target: Vector2i, radius: int) -> bool:
	return origin.distance_to(target) <= radius

# 获取圆形范围内所有格子
func get_cells_in_radius(origin: Vector2i, radius: int) -> Array:
	var result = []
	for x in range(-radius, radius+1):
		for y in range(-radius, radius+1):
			var pos = origin + Vector2i(x, y)
			if is_in_radius(origin, pos, radius):
				result.append(pos)
	return result

# 判断目标是否在扇形范围内
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

# 获取扇形范围内所有格子
func get_cells_in_sector(origin: Vector2i, direction: Vector2i, angle: float, radius: int) -> Array[Vector2i]:
	var result = []
	for pos in get_cells_in_radius(origin, radius):
		if is_in_sector(origin, pos, direction, angle, radius):
			result.append(pos)
	return result

# 判断两点间是否有视线遮挡
func has_line_of_sight(_origin: Vector2i, _target: Vector2i) -> bool:
	# TODO: 结合TileMap障碍属性实现Bresenham算法
	return true

# 获取区域内所有角色
func get_units_in_area(_area: Array[Vector2i]) -> Array:
	var result = []
	# TODO: 结合level_handler.get_character_list()实现
	return result

# 获取区域内所有物件/机关
func get_objects_in_area(_area: Array[Vector2i]) -> Array:
	var result = []
	# TODO: 结合场景物件管理实现
	return result
