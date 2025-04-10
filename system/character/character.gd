class_name Character
extends Area2D

@export_node_path("TileMapLayer") var space_tilemap = NodePath("..")
@onready var action_manager:ActionManager = $ActionManager
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	act(&"action",Vector2i(2,2))

func act(id:StringName,target:Vector2i) -> bool:
	#玩家执行行动，成功返回true。
	return action_manager.execute_action(id,target)
