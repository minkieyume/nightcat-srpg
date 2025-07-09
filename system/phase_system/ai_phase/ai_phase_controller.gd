class_name AIPhaseController
extends PhaseController
# AI状态机的抽象类

func before_action():
	pass

func _setup() -> void:
	controller_name = agent.id
	super()

func get_next_action():	
	var state = get_active_state()
	if state is AIPhaseController or state is AIPhase:
		await state.before_action()
		var action = await state.get_next_action()
		return action
	else:
		return null
