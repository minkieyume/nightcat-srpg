extends Phase

@export var prompt = "回合开始"

func _enter() -> void:
	print(prompt)
	call_deferred("dispatch", "next")
