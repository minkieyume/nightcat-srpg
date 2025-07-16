extends Node

@export var buffs :Array[Buff] = []

func get_buff(_id:String):
	for buff in buffs:
		if buff.id == _id:
			return buff
	return null

