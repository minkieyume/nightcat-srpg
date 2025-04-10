class_name SRPGToolkit
extends Node

enum MOVE_DIRECTION{DOWN=0,LEFT=1,RIGHT=2,UP=3}

static func get_direction_vector(direction:MOVE_DIRECTION) -> Vector2:
	match direction:
		0:
			return Vector2.DOWN
		1:
			return Vector2.LEFT
		2:
			return Vector2.RIGHT
		3:
			return Vector2.UP
		_:
			return Vector2.DOWN
