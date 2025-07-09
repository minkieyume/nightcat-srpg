class_name Unit
extends Node2D

## 单位的id，场景内的单位id不能重复。
@export var id = "unit1"
@export var part = "upart1"
## 移动速度。
@export var move_speed = 192

## 单位是否能穿透所有阻碍
@export var precing:bool = false

## 单位默认穿透的unit的组别
@export var preced_unit_groups:Array[String]

# 动画播放器插件
@onready var animation_player = $AnimationPlayer

#LimboHSM状态机插件
@onready var animation_machine: LimboHSM = $AnimationMachine
@onready var idle_state: LimboState = $AnimationMachine/IdleState
@onready var move_state: LimboState = $AnimationMachine/MoveState

var context:Dictionary

## 单位的朝向
var direction:Vector2i = Vector2i.DOWN:
	# 朝向改变
	set(d):
		direction = d
		emit_signal("direction_changed",direction)

signal direction_changed(direct:Vector2i)
signal path_end

func _ready() -> void:
	await LevelHandler.level_ready
	_init_animation_machine()
	var movement = LevelHandler.get_movement_server()

func _init_animation_machine() -> void:
	animation_machine.add_transition(idle_state, move_state,"move_start")
	animation_machine.add_transition(move_state, idle_state,"move_stop")
	animation_machine.initialize(self)
	animation_machine.set_active(true)

func change_face(face:String) -> bool:
	match face:
		"down":
			change_direction(Vector2i.DOWN)
		"left":
			change_direction(Vector2i.LEFT)
		"right":
			change_direction(Vector2i.RIGHT)
		"up":
			change_direction(Vector2i.UP)
		_:
			return false	
	return true

func change_direction(dir:Vector2i) -> bool:	
	if direction == dir:
		return true
	match dir:
		Vector2i.DOWN:
			direction = dir
			return true
		Vector2i.LEFT:
			direction = dir
			return true
		Vector2i.RIGHT:
			direction = dir
			return true
		Vector2i.UP:
			direction = dir
			return true
		_:
			return false

func step_path(path:Array[Vector2i],vdis:Vector2,map:TileMapLayer) -> void:
	# 沿着path批量移动
	var start = map.local_to_map(position)
	for point in path:
		await step(point - start,vdis)
		start = map.local_to_map(position)	
	emit_signal("path_end")

func step(dir:Vector2,vdis:Vector2) -> void:
	# 朝特定方向移动一段距离
	# dir:朝向的向量
	# vdis:距离的向量，x和y分别代表x方向和y方向的移动量。
	animation_machine.dispatch("move_start")
	change_direction(dir)
	var end = position+vdis*dir
	var dis = position.distance_to(end) # 计算绝对距离数值。
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",end,dis/move_speed)
	await tween.finished
	animation_machine.dispatch("move_stop")

func set_ctx(ctx:Dictionary):
	context.merge(ctx,true)

func clean_ctx():
	context.clear()
