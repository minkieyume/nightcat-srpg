class_name MenuManager
extends LimboHSM

@export var menu:Control
@export var transition:Dictionary[StringName,LimboState]
var context:Dictionary

signal cargo_send(cargo:Dictionary)

func _ready() -> void:
	add_event_handler("return",_return)
	for _menu in get_children():
		if _menu is MenuState or _menu is MenuManager:
			for event in _menu.transition.keys():
				var target = _menu.transition[event]
				_menu.cargo_send.connect(target._on_cargo_recieve)
				add_transition(_menu,target,event)
	initialize(self)
	set_active(true)

func _enter() -> void:
	pass

func _exit() -> void:
	emit_signal("cargo_send",context)

func _return(cargo:Dictionary) -> bool: # 返回到上级节点
	return false

func _on_cargo_recieve(cargo:Dictionary):
	context = cargo
