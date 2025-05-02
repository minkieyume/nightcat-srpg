class_name Character
# 处理角色状态与行为
# 与各个Server中介通信
extends Area2D

@export var move_speed = 96

@onready var action_manager = $ActionManager
@onready var animation_player = $AnimationPlayer

#LimboHSM状态机插件
@onready var hsm: LimboHSM = $LimboHSM
@onready var idle_state: LimboState = $LimboHSM/IdleState
@onready var move_state: LimboState = $LimboHSM/MoveState

var direction:Vector2i = Vector2i.DOWN:
	# 角色朝向
	set(d):
		direction = d
		emit_signal("direction_changed",direction)

signal direction_changed(direct:Vector2i)
signal path_end

func _ready() -> void:
	_init_state_machine()

func _init_state_machine() -> void:
	hsm.add_transition(idle_state, move_state,"move_start")
	hsm.add_transition(move_state, idle_state,"move_stop")
	hsm.initialize(self)
	hsm.set_active(true)

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
	hsm.dispatch("move_start")
	change_direction(dir)
	var end = position+vdis*dir
	var dis = position.distance_to(end) # 计算绝对距离数值。
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",end,dis/move_speed)
	await tween.finished
	hsm.dispatch("move_stop")

func get_action_list() -> Dictionary:
	return action_manager.action_list

func get_action_resource(id:StringName):
	return action_manager.get_action_resouce(id)
