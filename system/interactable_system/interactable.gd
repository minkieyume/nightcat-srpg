class_name Interactable
extends Node2D
## Interactable的接口类
## 要实现该类，只需要实现该类的全部方法，并添加interactable的组即可。

@export var id = "interactable1"

@export var move_speed = 192

signal path_end
signal finished
signal failed

func move_path(path:Array[Vector2i],vdis:Vector2,map:TileMapLayer) -> void:
	# 沿着path批量移动
	var start = map.local_to_map(position)
	for point in path:
		await move(point - start,vdis)
		start = map.local_to_map(position)
	emit_signal("path_end")

func move(dir:Vector2,vdis:Vector2) -> void:
	# 朝特定方向移动一段距离
	# dir:朝向的向量
	# vdis:距离的向量，x和y分别代表x方向和y方向的移动量。
	var end = position+vdis*dir
	var dis = position.distance_to(end) # 计算绝对距离数值。
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",end,dis/move_speed)
	await tween.finished

## 互动前的操作 
func before_interact(character:String,handler:LevelHandler):
	print(character)

## 与物体互动
func interact(character:String,handler:LevelHandler,ctx:Dictionary):
	print(character)
