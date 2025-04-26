class_name MenuManager
extends LimboHSM

@export var transition:Dictionary[StringName,LimboState]

func _ready() -> void:
	for _menu in get_children():
		if _menu is MenuState or _menu is MenuManager:
			for event in transition.keys():
				add_transition(_menu,transition[event],event)
	initialize(self)
	set_active(true)
