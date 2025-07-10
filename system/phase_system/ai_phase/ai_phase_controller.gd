class_name AIPhaseController
extends PhaseController
# AI状态机的抽象类

func before_action():
	var state = get_active_state()
	if state is AIPhaseController or state is AIPhase:
		await state.before_action()

func _setup() -> void:
	controller_name = agent.id
	super()

func _enter() -> void:
	super()
	await before_action()

func get_next_action():	
	var state = get_active_state()
	if state is AIPhaseController or state is AIPhase:		
		var action = await state.get_next_action()
		return action
	else:
		return null

func end_action():
	var state = get_active_state()
	if state is AIPhaseController or state is AIPhase:
		await state.end_action()
