extends Phase

func _enter() -> void:
	super()
	context.erase("actor")
	CommandBus.cat_send_command("menu",["setcargo","part",context["part"]])
	var part_characters = LevelHandler.get_characters().\
		filter(func(c):return LevelHandler.is_unit_in_group(c.id,"player")).\
		filter(func(c):return c.part == context["part"])
	context["actor"] = part_characters[0].id	
	LevelHandler.cat_set_camera_folllow_unit(context["actor"])
	dispatch("next")
	#call_deferred("dispatch","next")
	
