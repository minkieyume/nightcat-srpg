class_name Interactable
## 这是一个接口类
## 要实现该类，只需要实现该类的全部方法，并添加interactable的组即可。
## 也可以直接继承本类，虽然一般不建议这么做
extends Unit

signal interact_end

func end():
	emit_signal("interact_end")

## 互动前的操作 
func before_interact(_character:String,_ctx:Dictionary):
	print(_character)
	CommandBus.send_command("gamephase",["setcargo","mode","interact"])
	CommandBus.send_command("gamephase",["interact_sucess"])	

## 与物体互动
func interact(_character:String,_ctx:Dictionary):
	print(_character)
	CommandBus.send_command("gamephase",["setcargo","mode","end_interact"])
	CommandBus.send_command("gamephase",["interact_sucess"])
	call_deferred("end")
