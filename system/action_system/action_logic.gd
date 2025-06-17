class_name ActionLogic
extends Object
# 行动的抽象接口

func execute(character:String,target:Vector2i,handler:LevelHandler) -> bool:
	print(character,target,handler)
	return true
