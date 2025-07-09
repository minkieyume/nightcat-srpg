class_name SightRadius
## 扇形视野范围的判断类
extends Node2D

## 半径
@export var radius:float
## 范围角度
@export var degress:float
## 旋转角度
@export var rotation_deg:float
## 基准节点，代表的是玩家的节点
@export var base:Node2D

## 判断点是否在扇形范围内
func is_in_radius(target:Vector2) -> bool:
	# 距离判定
	var pos = base.position+self.position
	var distance = pos.distance_to(target)
	if distance > radius:
		return false

	# 角度判定
	var angle_to_target = (target - pos).angle()
	var angle_to_target_deg = rad_to_deg(angle_to_target)
	var rotated_angle_deg = angle_to_target_deg - rotation_deg
	var half_angle = degress / 2  # 扇形的半角度
	var start_angle = -half_angle  # 扇形起始角度
	var end_angle = half_angle    # 扇形结束角度

	# 如果目标点角度在扇形的角度范围内，返回 true
	if rotated_angle_deg >= start_angle and rotated_angle_deg <= end_angle:
		return true
	
	# 否则，返回 false
	return false

## 基于图块中心点判断图块是否在扇形内
func is_tile_in_radius(tile:Vector2i,quester:GridQuester) -> bool:
	var target = quester.quest_tile_center(tile)
	return is_in_radius(target)
	
## 获取视野范围内的全部图块
func get_tiles_in_sector(quester:GridQuester) -> Array:
	var results = []
	var origin = quester.quest_tile(base.position)
	var ranges = quester.quest_tiles_in_radius(origin,int(radius))
	for tile in ranges:
		if is_tile_in_radius(tile,quester):
			results.append(tile)
	return results
	#return quester.quest_tiles_in_sector(origin,Vector2i.LEFT,degress,int(radius))
