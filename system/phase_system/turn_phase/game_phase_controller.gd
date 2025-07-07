extends PhaseController

func _ready() -> void:
	CommandBus.command_send.connect(_on_level_handler_command_send)

func _on_level_handler_command_send(command:StringName, args:Array) -> void:
	super(command,args)
	if command == controller_name:
		match args[0]:
			"setcargo":
				return
			_:
				dispatch(args[0])
