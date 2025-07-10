# meta-name: ActionLogic
# meta-description: 行动的逻辑
# meta-default: true
# meta-space-indent: 4
extends ActionLogic

## 选择行动目标前的操作
func before_target_chose(action:Action):
	pass

## 行动预检查前的操作，这个阶段通常已选定目标
func before_precheck(action:Action):
	pass

## 行动的预检查，用于检查行动能否执行
func precheck(action:Action) -> bool:
	return true

## 行动的执行操作
func execute(action:Action):
	pass
