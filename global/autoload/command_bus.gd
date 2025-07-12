extends Node

signal command_send(command:StringName,args:Array)

@rpc("any_peer","call_local")
func send_command(command:StringName,args:Array):
	emit_signal("command_send",command,args)

func cat_send_command(command:StringName,args:Array):
	if MultiCat.should_sync():
		if is_multiplayer_authority():
			rpc("send_command",command,args)
	else:
		emit_signal("command_send",command,args)

func server_local_command(command:StringName,args:Array):
	if MultiCat.should_sync():
		if is_multiplayer_authority():
			emit_signal("command_send",command,args)
	else:
		emit_signal("command_send",command,args)
