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
	print("[PhaseController] 初始化状态机: ", name)
	print("[PhaseController] 子节点数量: ", get_children().size())
	
	for phase in get_children():
		print("[PhaseController] 处理子节点: ", phase.name, " 类型: ", phase.get_class())
		if phase is Phase or phase is PhaseController:
			print("[PhaseController] ", phase.name, " 的transition字典: ", phase.transition)
			for event in phase.transition.keys():
				var target = phase.transition[event]
				print("[PhaseController] 添加转换: ", phase.name, " --[", event, "]--> ", target.name if target else "null")
				phase.cargo_send.connect(target._on_cargo_recieve)
				add_transition(phase,target,event)
	
	# LimboHSM 会自动将第一个子节点设为初始状态
	var first_child = get_children()[0] if get_children().size() > 0 else null
	if first_child:
		print("[PhaseController] 第一个子节点: ", first_child.name)
	
	print("[PhaseController] 调用 initialize() 之前")
	initialize(self)
	print("[PhaseController] 调用 initialize() 之后")
	
	if first_child:
		print("[PhaseController] initialize后，第一个子节点是否激活: ", first_child.is_active())
	
	print("[PhaseController] 状态机初始化完成")

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
	print("[PhaseController] 启动状态机: ", name)
	print("[PhaseController] 调用 set_active(true) 之前")
	print("[PhaseController] 当前是否激活: ", is_active())
	
	var first_child = get_children()[0] if get_children().size() > 0 else null
	if first_child:
		print("[PhaseController] set_active前，第一个子节点是否激活: ", first_child.is_active())
	
	set_active(true)
	print("[PhaseController] 调用 set_active(true) 之后")
	print("[PhaseController] 当前是否激活: ", is_active())
	
	if first_child:
		print("[PhaseController] set_active后，第一个子节点是否激活: ", first_child.is_active())
		if first_child.is_active():
			print("[PhaseController] 第一个子节点已自动激活！")
		else:
			print("[PhaseController] 警告：第一个子节点没有自动激活！")
	
	print("[PhaseController] 状态机启动完成: ", name)
