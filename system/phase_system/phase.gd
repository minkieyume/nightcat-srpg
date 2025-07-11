class_name Phase
extends LimboState

var controller_name:String
@export var transition:Dictionary[StringName,LimboState]
var context:Dictionary:
	set(c):
		context = c
		emit_signal("context_changed")

signal cargo_send(cargo:Dictionary)
signal context_changed()
signal context_updated(id,content)

func _ready() -> void:
	CommandBus.command_send.connect(_on_handler_command_send)
	LevelHandler.level_ready.connect(_on_level_ready)

func _setup() -> void:
	pass

func _enter() -> void:
	pass

func _exit() -> void:
	if MultiCat.should_sync():
		if is_multiplayer_authority():
			rpc("send_cargo",context)
	else:
		send_cargo(context)

func _on_cargo_recieve(cargo:Dictionary):
	context = cargo

@rpc("authority","call_local")
func send_cargo(ctx:Dictionary):
	emit_signal("cargo_send",ctx)

func search_context(id):
	return context.get(id)

@rpc("authority","call_local")
func update_context(id,content):
	context[id] = content
	emit_signal("context_updated",id,content)

@rpc("authority","call_remote")
func sync(ctx:Dictionary):
	context = ctx	

func rpc_update_context(id,content):
	if MultiCat.should_sync():
		if is_multiplayer_authority():
			rpc("update_context",id,content)
	else:
		update_context(id,content)

@rpc("authority","call_local")
func remote_dispatch(event:StringName):
	dispatch(event)

func rpc_dispatch(event:StringName):
	if MultiCat.should_sync():		
		if is_multiplayer_authority():
			rpc("remote_dispatch",event)
	else:
		dispatch(event)

func _on_handler_command_send(command:StringName, args:Array) -> void:
	if command == controller_name:
		match args[0]:
			"setcargo":
				context.set(args[1],args[2])

func _on_level_ready():
	pass
