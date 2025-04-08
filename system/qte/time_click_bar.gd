extends Node2D
@onready var failed_area:ColorRect = $FailedArea
@onready var sucess_area:Area2D = $FailedArea/SuccessArea
@onready var hardsucess_area:Area2D = $FailedArea/SuccessArea/HardSucessArea

@onready var sucess_rect:ColorRect = $FailedArea/SuccessArea/SuccessRect
@onready var sucess_collision_shape = $FailedArea/SuccessArea/CollisionShape2D

@onready var hardsucess_rect:ColorRect = $FailedArea/SuccessArea/HardSucessArea/HardSucessRect
@onready var hardsucess_collision_shape = $FailedArea/SuccessArea/CollisionShape2D

@onready var zhizhen:Area2D = $FailedArea/ZhiZhen

@export var sucess_per :float= 0.4:
	set(s):
		sucess_per = s
@export var hard_sucess_per :float= 0.05:
	set(h):
		hard_sucess_per = h
@export var sucess_off :float = 40.0
@export var hard_off :float = 10.0
@export var stop_sec :float = 2.0
@export var rate :float = 100.0

var zhizhen_right = true
var zhizhen_stop = false

func _ready():
	#矩形大小配置
	var sucess_shape = RectangleShape2D.new()
	var hardsucess_shape  = RectangleShape2D.new()
	sucess_rect.size.x = failed_area.size.x*sucess_per
	hardsucess_rect.size.x = failed_area.size.x*hard_sucess_per
	sucess_shape.size = sucess_rect.size/2
	hardsucess_shape.size = hardsucess_rect.size/2
	sucess_collision_shape = sucess_shape
	hardsucess_collision_shape = hardsucess_shape
	sucess_area.position.x = sucess_area.position.x + sucess_off
	hardsucess_area.position.x = hardsucess_area.position.x + hard_off
	get_tree().create_timer(stop_sec).connect("timeout",_on_stop_sec_timeout)

func zhizhen_move(delta: float):
	var zsx = zhizhen.position.x
	if zsx<=1:
		zhizhen_right = true
	elif zsx>=failed_area.size.x-1:
		zhizhen_right = false

	if zhizhen_right:
		zhizhen.position.x = zsx+rate*delta
	else:
		zhizhen.position.x = zsx-rate*delta	

func _process(delta: float) -> void:
	if not zhizhen_stop:
		zhizhen_move(delta)

func _on_stop_sec_timeout() -> void:
	if not zhizhen_stop:
		zhizhen_stop = true
		zhizhen.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("QTE"):
		zhizhen_stop = true
