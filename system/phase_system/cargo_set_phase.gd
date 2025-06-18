extends Phase
@export var cargos:Dictionary

func _enter() -> void:
	context.merge(cargos,true)
	dispatch("next")

