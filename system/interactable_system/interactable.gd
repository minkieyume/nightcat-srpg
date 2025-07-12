class_name Interactable
## 这是一个接口类
## 要实现该类，只需要实现该类的全部方法，并添加interactable的组即可。
## 也可以直接继承本类，虽然一般不建议这么做
extends Unit

signal interact_end

func end():
	emit_signal("interact_end")

## 互动前的操作
@rpc("authority","call_local")
func before_interact(_character:String,_ctx:Dictionary):
	CommandBus.send_command("gamephase",["wait"])
	CommandBus.send_command("gamephase",["setcargo","mode","interact"])
	CommandBus.send_command("gamephase",["interact_sucess"])

func cat_before_interact(character:String,ctx:Dictionary):
	if MultiCat.should_sync():
		if is_multiplayer_authority():
			rpc("before_interact",character,ctx)
	else:
		before_interact(character,ctx)

func precheck(_character:String,_ctx:Dictionary) -> bool:	
	return true

## 与物体互动
@rpc("authority","call_local")
func interact(_character:String,_ctx:Dictionary):
	CommandBus.send_command("gamephase",["setcargo","mode","end_interact"])
	CommandBus.send_command("gamephase",["interact_sucess"])
	call_deferred("end")

func cat_interact(character:String,ctx:Dictionary):
	if MultiCat.should_sync():
		if is_multiplayer_authority():
			rpc("interact",character,ctx)
	else:
		interact(character,ctx)
