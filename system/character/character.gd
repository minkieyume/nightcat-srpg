class_name Character
extends Area2D

func _ready() -> void:
	pass

func act(action:Action,target:Vector2i):
	action.act(target)
