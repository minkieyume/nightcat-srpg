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
