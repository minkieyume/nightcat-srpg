extends Node
@export_node_path("Character") var character = NodePath("..")

func _ready() -> void:
	for action in get_children():
		action.character = character
