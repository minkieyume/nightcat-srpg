extends GridMapServer

func _ready() -> void:
	super()

func _on_action_requested(action_manager:ActionManager,\
	id:StringName,target:Vector2i):
	var result = action_manager.execute_action(id,target,grid_map)
	if !result:
		push_warning("行动失败")
