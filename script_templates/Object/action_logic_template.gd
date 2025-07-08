# meta-name: ActionLogic
# meta-description: 行动的逻辑
# meta-default: true
# meta-space-indent: 4
extends ActionLogic

func before_target_chose(action:Action) -> bool:
	return true

func before_run(action:Action) -> bool:
	return true

func execute(action:Action) -> bool:
	return true
