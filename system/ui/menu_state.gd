class_name MenuState
extends LimboState

@export var menu:Control
@export var transition:Dictionary[StringName,LimboState]
var context:Dictionary

signal cargo_send(cargo:Dictionary)

func _ready() -> void:
	add_event_handler("return",_return)

func _enter() -> void:
	if is_instance_valid(menu):
		menu.visible = true
		menu.grab_focus()

func _exit() -> void:
	emit_signal("cargo_send",context)
	if is_instance_valid(menu):
		menu.visible = false
		menu.release_focus()

func _return(cargo:Dictionary) -> bool: # 返回到上级节点
	return false

func _on_cargo_recieve(cargo:Dictionary):
	print(cargo)
	context = cargo
