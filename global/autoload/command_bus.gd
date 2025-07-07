extends Node

signal command_send(command:StringName,args:Array)

func send_command(command:StringName,args:Array):
	emit_signal("command_send",command,args)
