class_name StateAI
extends LimboHSM
# AI状态机的抽象类

func _init_ai():
	pass

func run_current_state(): # 运行当前状态的逻辑
	var state = get_active_state()
	if state is StateAIState:
		state._transition_precheck()
		state = get_active_state()
		state._state_logic()
