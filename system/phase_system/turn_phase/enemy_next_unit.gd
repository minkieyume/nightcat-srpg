extends Phase

@export var enemy_parts:Array[String]

var parts:Array[String]

func _setup() -> void:
	super()
	parts = enemy_parts.duplicate()

func _enter() -> void:
	super()
	if !parts.is_empty():
		context["part"] = parts.pop_front()
		call_deferred("dispatch","next")
	else:
		parts = enemy_parts.duplicate()
		call_deferred("dispatch","end")
