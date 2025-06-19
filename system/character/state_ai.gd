class_name StateAI
extends LimboHSM
# AI状态机的抽象类

func _init_ai():
	pass

func run_current_state(handler:LevelHandler): # 运行当前状态的逻辑
	var state = get_active_state()
	if state is StateAIState:
		state._state_logic(handler)
