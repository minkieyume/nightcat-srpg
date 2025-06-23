extends PhaseController


func _on_level_handler_command_send(command:StringName, args:Array) -> void:
	if command == "menu":
		if !args.is_empty():
			dispatch(args[0])
