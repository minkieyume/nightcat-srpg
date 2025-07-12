class_name PhaseController
extends LimboHSM

@export var controller_name:String = ""
@export var transition:Dictionary[StringName,LimboState]
var context:Dictionary:
	set(c):
		context = c
		emit_signal("context_changed")

var has_started = false

signal cargo_send(cargo:Dictionary)
signal started()
signal stopped()

func _ready() -> void:
	CommandBus.command_send.connect(_on_handler_command_send)
	_init_state_machine()
	LevelHandler.level_ready.connect(_on_level_ready)	
	
func _init_state_machine():	
	for phase in get_children():
		if phase is Phase or phase is PhaseController:			
			for event in phase.transition.keys():
				var target = phase.transition[event]
				phase.cargo_send.connect(target._on_cargo_recieve)
				add_transition(phase,target,event)

# @rpc("authority","call_local")
# func remote_dispatch(event:StringName):
# 	dispatch(event)

# func rpc_dispatch(event:StringName):
# 	if MultiCat.is_online():		
# 		if is_multiplayer_authority():
# 			rpc("remote_dispatch",event)
# 	else:
# 		dispatch(event)

func _setup():	
	for phase in get_children():
		if phase is Phase or phase is PhaseController:
			phase.controller_name = controller_name

func _enter() -> void:
	var state = initial_state
	state._on_cargo_recieve(context)

func _exit() -> void:
	send_cargo(context)
	# if MultiCat.is_online():
	# 	if is_multiplayer_authority():
	# 		rpc("send_cargo",context)
	# else:
	# 	send_cargo(context)

@rpc("authority","call_local")
func send_cargo(ctx:Dictionary):
	emit_signal("cargo_send",ctx)

func search_context(id):
	return context.get(id)

@rpc("authority","call_local")
func update_context(id,content):
	context[id] = content
	emit_signal("context_updated",id,content)

func get_active_state_list() -> Array:
	var result = []
	var leaf = get_leaf_state()
	var active = get_active_state()
	while leaf != active:
		result.append(leaf.get_path())
		leaf = leaf.get_parent()
	result.append(active.get_path())
	return result

func get_context() -> Dictionary:
	var leaf = get_leaf_state()
	return leaf.context

# @rpc("authority","call_remote")
# func sync(ctx:Dictionary,state_tree:Array):
# 	var state = get_node(state_tree.pop_back())
# 	change_active_state(state)
# 	print(get_active_state())
# 	if state is PhaseController:
# 		state.sync(ctx,state_tree)
# 	elif state is Phase:
# 		state.sync(ctx)

# @rpc("authority","call_remote")
# func queue_sync(ctx:Dictionary,state_tree:Array):
# 	if not has_started:
# 		await started
# 	else:
# 		await get_tree().process_frame
# 	sync(ctx,state_tree)

# func rpc_update_context(id,content):
# 	if MultiCat.is_online():
# 		if is_multiplayer_authority():
# 			rpc("update_context",id,content)
# 	else:
# 		update_context(id,content)

func _on_cargo_recieve(cargo:Dictionary):
	context = cargo

# 启动状态机
func start():
	set_active(true)
	has_started = true
	emit_signal("started")

func stop():
	set_active(false)
	has_started = false
	emit_signal("stopped")

func _on_handler_command_send(command:StringName, args:Array) -> void:
	if command == controller_name:
		match args[0]:
			"setcargo":
				context.set(args[1],args[2])

func _on_level_ready():
	pass
