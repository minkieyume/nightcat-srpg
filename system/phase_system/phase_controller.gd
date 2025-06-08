class_name PhaseController
extends LimboHSM

@export var level_handler:LevelHandler
@export var transition:Dictionary[StringName,LimboState]
var context:Dictionary:
	set(c):
		context = c
		emit_signal("context_changed")

signal cargo_send(cargo:Dictionary)

func _ready() -> void:
	_init_state_machine()
	
func _init_state_machine():
	for phase in get_children():
		if phase is Phase or phase is PhaseController:
			for event in phase.transition.keys():
				var target = phase.transition[event]
				phase.cargo_send.connect(target._on_cargo_recieve)
				add_transition(phase,target,event)
	# LimboHSM 会自动将第一个子节点设为初始状态
	initialize(self)

func _setup():
	for phase in get_children():
		if phase is Phase or phase is PhaseController:
			phase.level_handler = level_handler

func _enter() -> void:
	pass

func _exit() -> void:
	emit_signal("cargo_send",context)

func _on_cargo_recieve(cargo:Dictionary):
	context = cargo

# 启动状态机
func start():
	set_active(true)
	# 确保初始状态被激活
	var first_child = get_children()[0] if get_children().size() > 0 else null
	if first_child and not first_child.is_active():
		first_child._enter()
