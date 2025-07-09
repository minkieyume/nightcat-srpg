class_name AICharacter
extends Character

@export var ai:AIPhaseController

func _ready() -> void:
	super()
	ai.initialize(self)
	ai.set_active(true)
