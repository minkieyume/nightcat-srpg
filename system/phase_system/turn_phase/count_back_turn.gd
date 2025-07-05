extends Phase
# 计次，如果未达到次数，则返回到回退阶段，达到次数则进入下个阶段。

@export var back_twice:int

func _enter() -> void:
	if !context.has("back_twice"):
		context["back_twice"] = 0
	if context["back_twice"] >= back_twice:
		context["back_twice"] = 0
		dispatch("next")
	else:		
		context["back_twice"]+=1
		dispatch("back")
