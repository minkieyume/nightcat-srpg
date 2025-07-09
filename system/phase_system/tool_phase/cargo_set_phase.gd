extends Phase
@export var cargos:Dictionary

func _enter() -> void:
	context.merge(cargos.duplicate(true),true)	
	call_deferred("dispatch","next")	
