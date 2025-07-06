extends GridMapServer

func _ready() -> void:
	for character in level_handler.get_character_array():
		character.update_sight_view(level_handler)
		character.sight_updated.connect(_on_sight_updated)		

func _on_sight_updated(id:String):
	var character = level_handler.get_character(id)
	character.update_sight_view(level_handler)
