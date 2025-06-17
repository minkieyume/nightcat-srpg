class_name ActionFactory
extends GridMapServer
# 处理角色的行动请求

func _ready() -> void:
	super()

func _on_action_requested(action_manager:ActionManager,\
	id:StringName,target:Vector2i):
	var result = action_manager.execute_action(id,target,grid_map)
	if !result:
		push_warning("行动失败")

func create_action(requester:String,id:StringName,target:Vector2i) -> Action:
#	print("[ActionFactory]",requester)
	var action_resource = level_handler.get_character_action(requester,id)
	var action = Action.new()
	var action_logic:GDScript = action_resource.action_logic
	action.requester = requester
	action.level_handler = level_handler
	action.resource = action_resource
	action.action_range = action_resource.action_range
	action.logic = action_logic.new()
	action.target = target
	return action
