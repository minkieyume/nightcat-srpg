class_name MoveAction
extends Action

func execute(character:Character,target:Vector2i) -> bool:
	character.move_to(target)
	return true
