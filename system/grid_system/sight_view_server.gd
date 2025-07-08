extends GridMapServer

func _ready() -> void:
	for character in LevelHandler.get_character_array():
		if !character.is_in_group("player"):
			character.update_sight_view(LevelHandler)
			character.sight_updated.connect(_on_sight_updated)

func _on_sight_updated(id:String):
	var character = LevelHandler.get_character(id)
	character.update_sight_view(LevelHandler)
