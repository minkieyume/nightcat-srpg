extends Phase
@export var cargos:Dictionary

func _enter() -> void:
	context.merge(cargos,true)
	dispatch("next")

func _on_level_handler_command_send(command:StringName, args:Array) -> void:
	if command == "setcargo":
		cargos[args[0]] = args[1]
