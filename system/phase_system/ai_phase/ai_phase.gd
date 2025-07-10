class_name AIPhase
extends Phase

func _enter():
	super()
	await before_action()

func get_next_action():
	return null

func before_action():
	pass

func end_action():
	pass
