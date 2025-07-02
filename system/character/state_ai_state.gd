class_name StateAIState
extends LimboState

func _state_logic(handler:LevelHandler):
	print(handler)

func _transition_precheck(handler:LevelHandler):
	print(handler)
