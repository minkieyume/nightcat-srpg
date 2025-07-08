extends ActionLogic

## 接收到移动结束的信号
signal recieved_end

## 移动结果
var move_result = false

func before_target_chose(action:Action) -> bool:	
	var quester = LevelHandler.get_grid_quester()		

	# 更新行动范围配置
	var blocked_tiles = quester.quest_block_tiles()
	var deter_array = action.clac_action_range()
	deter_array = deter_array.filter(func(x):return not blocked_tiles.has(x))
	action.action_range.type = 0
	action.action_range.deter_array = deter_array
	return true

func before_run(action:Action) -> bool:	
	var agent = LevelHandler.get_character(action.requester)
	var grid_map = LevelHandler.get_grid_map()
	var start = grid_map.local_to_map(agent.position)
	var resource = action.resource
	# OOP式调用LevelLevelHandler的get_path_length
	var ap_cost = LevelHandler.get_path_length(start, action.target)

	# 设置行动的AP消费
	resource.ap_cost = ap_cost
	return true

func execute(action:Action) -> bool:
	var character = action.requester
	var target = action.target
	var agent = LevelHandler.get_character(character)
	var server = LevelHandler.get_movement_server()
	server.move_failed.connect(_on_move_failed)
	agent.path_end.connect(_on_path_end)
	
	# 发送移动命令
	CommandBus.send_command("move_unit", [character, target])
	await recieved_end
	server.move_failed.disconnect(_on_move_failed)
	agent.path_end.disconnect(_on_path_end)
	return move_result

func _on_path_end():
	move_result = true
	call_deferred("emit_signal","recieved_end")

func _on_move_failed():	
	move_result = false
	call_deferred("emit_signal","recieved_end")

#func execute(character:Character,grid_map:TileMapLayer,\
#	target:Vector2i) -> bool:
#	character.request_move_to(target)
#	return true
