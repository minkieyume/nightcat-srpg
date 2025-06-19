extends Character

@export var ai:StateAI

func _ready() -> void:
	super()
	ai._init_ai()
