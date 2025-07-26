extends Unit

@export var disappear_count:int = 3
var turn_count:int

func turn():
	turn_count+=1
	if turn_count > disappear_count:
		LevelHandler.remove_unit(id)
