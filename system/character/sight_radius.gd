class_name SightRadius
## 扇形视野范围的判断类
extends Node2D

@export var radius:float
@export var degress:float
@export var rotation_deg:float
@export var base:Node2D

func is_in_radius(target:Vector2):
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

func is_tile_in_radius(tile:Vector2i,quester:GridQuester):
	var target = quester.quest_tile_center(tile)
	return is_in_radius(target)
	
