class_name Enemy
extends AICharacter

func _ready() -> void:
	await super()
	show_sight_view()
