class_name Interactable
extends Node2D

@export var id = "interactable1"

# 与物体互动
func interact(character:String,handler:LevelHandler):
	print(character)
