class_name CharacterController
# 代理接管一切操控角色的指令
extends Node

@export var level:Level
@export var level_handler:LevelHandler

@export var id:String = "player"
@export var handled_characters:Array[String]

func _ready() -> void:
	if !level_handler:
		level_handler = level.get_handler()

func is_character_handled(id:String) -> bool:
	if id in handled_characters:
		return true
	else:
		return false
