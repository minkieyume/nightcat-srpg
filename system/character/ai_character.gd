class_name AICharacter
extends Character

@export var ai:AIPhaseController
@export var patrol_path:Path2D

func _on_level_ready():
	super()
	ai.initialize(self)
	ai.set_active(true)

## 获取AI角色的巡逻路径。
func get_patrol_path() -> Array[Vector2i]:
	var path:Array[Vector2i] = []
	if !patrol_path:
		return path

	# 获取曲线的顶点
	var curve = patrol_path.curve
	var points:Array[Vector2] = []
	for i in range(curve.point_count):
		var ppos = curve.get_point_position(i)
		points.append(patrol_path.to_global(ppos))

	# 获取地图坐标
	var map = LevelHandler.get_grid_map()
	for point in points:
		var p = map.local_to_map(map.to_local(point))
		path.append(p)
	print(path)
	return path
