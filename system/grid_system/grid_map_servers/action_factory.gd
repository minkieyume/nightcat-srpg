class_name ActionFactory
extends GridMapServer
## 创建行动的构造类

func _ready() -> void:
	super()

func _on_action_requested(action_manager:ActionManager,\
	id:StringName,target:Vector2i):
	var result = await action_manager.execute_action(id,target,grid_map)
	if !result:
		push_warning("行动失败")

## 在当前关卡环境中创建新的行动并返回该行动。
func create_action(requester:String,id:StringName) -> Action:
#	print("[ActionFactory]",requester)
	var action_resource:ActionResource = level_handler.get_character_action(requester,id)
	var action = Action.new()
	var action_logic:GDScript = action_resource.action_logic
	action.requester = requester
	action.level_handler = level_handler
	action.resource = action_resource.duplicate(true)
	action.action_range = action_resource.action_range.duplicate(true)
	action.logic = action_logic.new()
	return action
