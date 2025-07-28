extends PhaseMenu
@onready var failed_area:ColorRect = $FailedArea
@onready var sucess_area:Area2D = $FailedArea/SuccessArea
@onready var hardsucess_area:Area2D = $FailedArea/SuccessArea/HardSucessArea

@onready var sucess_rect:ColorRect = $FailedArea/SuccessArea/SuccessRect
@onready var sucess_collision_shape = $FailedArea/SuccessArea/CollisionShape2D

@onready var hardsucess_rect:ColorRect = $FailedArea/SuccessArea/HardSucessArea/HardSucessRect
@onready var hardsucess_collision_shape = $FailedArea/SuccessArea/HardSucessArea/CollisionShape2D

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
var zhizhen_stop = true

var result = 0 # 结果：0为失败，1为成功，2为艰难成功

signal qte_finished

func _ready():
	super()	
	#矩形大小配置
	var s_shape = RectangleShape2D.new()
	var hs_shape = RectangleShape2D.new()
	
	var sizex = failed_area.size.x*sucess_per
	var hsizex = failed_area.size.x*hard_sucess_per
	
	sucess_rect.size.x = sizex
	hardsucess_rect.size.x = hsizex
	
	s_shape.size = Vector2(sizex,sucess_rect.size.y)
	hs_shape.size = Vector2(hsizex,sucess_rect.size.y)
	
	sucess_area.position.x = sucess_area.position.x + sucess_off
	hardsucess_area.position.x = hardsucess_area.position.x + hard_off
		
	sucess_collision_shape.set_shape(s_shape)
	hardsucess_collision_shape.set_shape(hs_shape)

	sucess_collision_shape.position.x = s_shape.size.x/2
	hardsucess_collision_shape.position.x = hs_shape.size.x/2
	
	

func _phase_enter() -> void:
	super()
	zhizhen_stop = false
	get_tree().create_timer(stop_sec).connect("timeout",_on_stop_sec_timeout)

func _phase_exit() -> void:
	super()
	zhizhen.position.x = 1

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
		check_result()
		phase.apply_qte_result(result)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("QTE"):
		zhizhen_stop = true
		check_result()
		phase.apply_qte_result(result)

func check_result():
	if hardsucess_area.overlaps_area(zhizhen):
		result = 2
	elif sucess_area.overlaps_area(zhizhen):
		result = 1
	else:
		result = 0
