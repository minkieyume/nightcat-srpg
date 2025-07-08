class_name StateAI
extends LimboHSM
# AI状态机的抽象类

func _init_ai():
	pass

func before_action():
	pass

func get_next_action():
	var state = get_active_state()
	if state is StateAIState or state is StateAI:
		await state.before_action()
		var action = await state.get_next_action()
		return action
	else:
		return null
