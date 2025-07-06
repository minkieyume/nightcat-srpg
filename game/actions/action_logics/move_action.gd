extends ActionLogic

## 接收到移动结束的信号
signal recieved_end

## 移动结果
var move_result = false

func execute(character:String, target:Vector2i, handler:LevelHandler) -> bool:
	var agent = handler.get_character(character)
	var grid_map = handler.get_grid_map()
	var start = grid_map.local_to_map(agent.position)
	var server = handler.get_movement_server()
	server.move_failed.connect(_on_move_failed)
	agent.path_end.connect(_on_path_end)

	# OOP式调用LevelHandler的get_path_length
	var ap_cost = handler.get_path_length(start, target)

	# 设置行动的AP消费
	if agent.can_consume_ap(ap_cost):
		agent.consume_ap(ap_cost)
	else:
		# 若行动开销超过AP，则行动执行失败。
		return false
	
	# 发送移动命令
	handler.send_command("move_character", [character, target])
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
