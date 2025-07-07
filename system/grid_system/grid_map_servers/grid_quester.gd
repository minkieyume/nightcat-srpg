class_name GridQuester
## 从地图中查询信息并返回
extends Node

## 关卡管理器
@export var level_handler:LevelHandler

func _ready() -> void:
	level_handler.grid_quester = self

## 在给定位置搜寻匹配的角色，返回角色id，如果没有则返回空字符串
func quest_character(target:Vector2i) -> String:
	var character_list = level_handler.get_character_dict()
	var grid_map = level_handler.get_grid_map()
	for character_key in character_list.keys():
		var character = character_list[character_key]
		if grid_map.local_to_map(character.position) == target:
			return character_key
	return ""

## 在给定位置搜寻可互动物体，返回物体id，如果没有则返回空字符串
func quest_interactable(target:Vector2i) -> String:
	var interactable_list = level_handler.get_interactable_list()
	var grid_map = level_handler.get_grid_map()
	for ikey in interactable_list.keys():
		var character = interactable_list[ikey]
		if grid_map.local_to_map(character.position) == target:
			return ikey
	return ""

## 获取图块坐标。
func quest_tile_position(target:Vector2i) -> Vector2:
	var grid_map = level_handler.get_grid_map()
	return grid_map.map_to_local(target)
	
## 获取图块中点坐标。
func quest_tile_center(target:Vector2i) -> Vector2:
	var grid_map = level_handler.get_grid_map()
	var tile_pos = grid_map.map_to_local(target)
	var tile_size = grid_map.tile_set.tile_size
	return tile_pos+Vector2(tile_size/2)

## 获取坐标对应的图块
func quest_tile(target:Vector2) -> Vector2i:
	var grid_map = level_handler.get_grid_map()
	return grid_map.local_to_map(target)

func quest_block_tiles() -> Array:
	var grid_map:GridMapLayer = level_handler.get_grid_map()
	var tiles = grid_map.get_used_cells()
	return tiles.filter(grid_map.is_cell_block)

func quest_passable_tiles() -> Array:
	var grid_map:GridMapLayer = level_handler.get_grid_map()
	var tiles = grid_map.get_used_cells()
	return tiles.filter(grid_map.is_cell_passable)

func is_tile_passable(pos:Vector2i) -> bool:
	var grid_map:GridMapLayer = level_handler.get_grid_map()
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
	var grid_map:GridMapLayer = level_handler.get_grid_map()
	for tile in Geometry2D.bresenham_line(origin,target):
		if grid_map.is_cell_block(tile):
			return true
	return false

# 获取区域内所有角色
func quest_character_in_area(area: Array) -> Array:
	var result = []
	for character in level_handler.get_character_array():
		var c_pos = level_handler.get_character_position(character.id)
		if c_pos in area:
			result.append(character)
	return result

# 获取区域内所有物件/机关
func get_interactable_in_area(area: Array) -> Array:
	var result = []
	for interactable in level_handler.get_interactable_list():
		var c_pos = level_handler.get_interactable_position(interactable)
		if c_pos in area:
			result.append(interactable)
	return result
