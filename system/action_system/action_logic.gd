class_name ActionLogic
extends Object
## 行动的抽象接口

func before_target_chose(action:Action) -> int:
	return 1

func action_prerun(action:Action) -> int:
	return 1

func execute(action:Action) -> bool:
	return true
