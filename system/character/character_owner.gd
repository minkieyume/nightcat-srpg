class_name CharacterOwner
# 角色的拥有者，用于确立角色的身份，确保角色能操控
extends Node

@export var level:Level

@export var id:String = "player"
@export var handled_characters:Array[String]

func is_character_handled(id:String) -> bool:
	if id in handled_characters:
		return true
	else:
		return false
