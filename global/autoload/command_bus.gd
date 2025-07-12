extends Node

signal command_send(command:StringName,args:Array)

@rpc("any_peer","call_remote")
func send_command(command:StringName,args:Array):
	emit_signal("command_send",command,args)

## 由客户端发起的远程调用方式，如果是服务器，则额外本地调用
func rpc_send_command(command:StringName,args:Array):
	if MultiCat.is_online():
		rpc("send_command",command,args)
		if is_multiplayer_authority():
			emit_signal("command_send",command,args)
	else:
		emit_signal("command_send",command,args)

## 服务端广播给客户端，同时本地运行的命令发送方式
func cat_send_command(command:StringName,args:Array):
	if MultiCat.is_online():
		if is_multiplayer_authority():
			rpc("send_command",command,args)
			emit_signal("command_send",command,args)
	else:
		emit_signal("command_send",command,args)

## 由服务端自身给本地发命令的命令，通常用于Action调用
func server_local_command(command:StringName,args:Array):
	if MultiCat.is_online():
		if is_multiplayer_authority():
			emit_signal("command_send",command,args)
	else:
		emit_signal("command_send",command,args)
