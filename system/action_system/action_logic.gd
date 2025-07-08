class_name ActionLogic
extends Object
## 行动的抽象接口

func before_target_chose(action:Action) -> bool:
	return true

func before_run(action:Action) -> bool:
	return true

func execute(action:Action) -> bool:
	return true
