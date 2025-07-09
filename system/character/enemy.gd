class_name Enemy
extends AICharacter

@export var chase_radius:int = 5

func _ready() -> void:
	await super()
	show_sight_view()
