extends Phase

func _enter() -> void:
	level_handler.send_command("menu",["action"])
