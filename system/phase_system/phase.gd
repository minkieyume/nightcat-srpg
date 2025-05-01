class_name Phase
extends LimboState

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
	pass

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
