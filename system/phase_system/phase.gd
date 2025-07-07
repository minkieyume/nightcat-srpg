class_name Phase
extends LimboState

var controller_name:String
var level_handler:LevelHandler
@export var transition:Dictionary[StringName,LimboState]
var context:Dictionary:
	set(c):
		context = c
		emit_signal("context_changed")

signal cargo_send(cargo:Dictionary)
signal context_changed()
signal context_updated(id,content)

func _ready() -> void:
	CommandBus.command_send.connect(_on_level_handler_command_send)

func _enter() -> void:
	pass

func _exit() -> void:
	send_cargo(context)

func _on_cargo_recieve(cargo:Dictionary):
	context = cargo

func send_cargo(ctx:Dictionary):
	emit_signal("cargo_send",ctx)

func search_context(id):
	return context.get(id)

func update_context(id,content):
	context[id] = content
	emit_signal("context_updated",id,content)

func _on_level_handler_command_send(command:StringName, args:Array) -> void:
	if command == controller_name:
		match args[0]:
			"setcargo":
				context.set(args[1],args[2])
