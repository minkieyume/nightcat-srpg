extends Node

signal command_send(command:StringName,args:Array)

@rpc("any_peer")
func send_command(command:StringName,args:Array):
	emit_signal("command_send",command,args)

func rpc_send_command(command:StringName,args:Array):
	if MultiCat.should_sync():
		rpc("send_command",command,args)
	else:
		emit_signal("command_send",command,args)
