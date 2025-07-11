class_name AICharacter
extends Character

@export var ai:AIPhaseController

func _on_level_ready():
	super()
	ai.initialize(self)
	ai.set_active(true)
