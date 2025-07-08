extends PhaseController

func _on_handler_command_send(command:StringName, args:Array) -> void:
	super(command,args)
	if command == controller_name:
		match args[0]:
			"setcargo":
				return
			_:
				dispatch(args[0])
