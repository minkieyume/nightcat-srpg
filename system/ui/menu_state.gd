class_name MenuState
extends LimboState

@export var menu:Control
@export var transition:Dictionary[StringName,LimboState]

func _ready() -> void:
	add_event_handler("return",_return)

func _enter() -> void:
	if is_instance_valid(menu):
		menu.visible = true
		menu.grab_focus()

func _exit() -> void:
	if is_instance_valid(menu):
		menu.visible = false
		menu.release_focus()

func _return(): # 返回到上级节点
	return false
