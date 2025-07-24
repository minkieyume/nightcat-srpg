extends PhaseController

@export var hide:MenuPhase
@export var grid_target_choser:MenuPhase
@export var action_choser:MenuPhase

func _on_handler_command_send(command:StringName, args:Array) -> void:	
	super(command,args)
	MenuHandler.menu_manager = self
	if MultiCat.is_online():
		if is_multiplayer_authority():
			rpc("menu_commend_recive",command,args)
	else:
		menu_commend_recive(command,args)

@rpc("authority","call_local")
func menu_commend_recive(command:StringName, args:Array):
	if command == controller_name:
		match args[0]:
			"setcargo":
				return
			_:
				if MultiCat.is_online():
					if context.has("part"):
						var agents = MultiCat.get_agents()
						var player_id = multiplayer.get_unique_id()
						var agen = agents["%d"%player_id]
						if agen.part == context["part"]:
							dispatch(args[0])
				else:
					dispatch(args[0])

func _exit() -> void:
	send_cargo(context)
