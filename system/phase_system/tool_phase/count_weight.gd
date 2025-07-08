extends Phase

func _setup() -> void:
	super()

func _enter() -> void:
	super()
	var characters:Array = LevelHandler.get_characters().filter(func(c):return c.part == context["part"])
	characters.sort_custom(sort_character)
	context["units"] = characters
	call_deferred("dispatch","next")

func sort_character(a:Character,b:Character) -> bool:
	if a.weight > b.weight:
		return true
	else:
		return false
