class_name PhaseController
extends LimboHSM

@export var controller_name:String = ""
@export var transition:Dictionary[StringName,LimboState]
var context:Dictionary:
	set(c):
		context = c
		emit_signal("context_changed")

signal cargo_send(cargo:Dictionary)

func _ready() -> void:
	CommandBus.command_send.connect(_on_handler_command_send)
	_init_state_machine()
	await LevelHandler.level_ready
	
func _init_state_machine():	
	for phase in get_children():
		if phase is Phase or phase is PhaseController:			
			for event in phase.transition.keys():
				var target = phase.transition[event]
				phase.cargo_send.connect(target._on_cargo_recieve)
				add_transition(phase,target,event)


func _setup():	
	for phase in get_children():
		if phase is Phase or phase is PhaseController:			
			phase.controller_name = controller_name

func _enter() -> void:
	var state = initial_state
	state._on_cargo_recieve(context)

func _exit() -> void:
	emit_signal("cargo_send",context)

func _on_cargo_recieve(cargo:Dictionary):
	context = cargo

# 启动状态机
func start():
	set_active(true)

func stop():
	set_active(false)

func _on_handler_command_send(command:StringName, args:Array) -> void:
	if command == controller_name:
		match args[0]:
			"setcargo":
				context.set(args[1],args[2])
