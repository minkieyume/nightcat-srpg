extends StateAIState

func _state_logic(handler:LevelHandler):
	var players = get_tree().get_nodes_in_group("player")
	var factory = handler.get_action_factory()
	var self_pos = handler.get_character_position(agent.id)

	# 获取距离最近的玩家坐标
	var min_pos:Vector2i
	for player in players:
		var pos = handler.get_character_position(player.id)
		if !min_pos:
			min_pos = pos
		else:
			var distance = self_pos.distance_to(pos)
			var last_distance = self_pos.distance_to(min_pos)
			if distance < last_distance:
				min_pos = pos

	var action:Action = factory.create_action(agent.id,&"move",min_pos-Vector2i(1,1))
	var range = action.clac_action_range(self_pos)
	if action.is_target_valid(range):
		action.execute()
		#临时方案，后面得改成选择最近的没有障碍物的点。
	else:
		# 重设为距离最近的坐标
		var player_pos = min_pos
		min_pos = range[0]
		for r in range:
			var distance = r.distance_to(player_pos)
			var last_distance = r.distance_to(player_pos)
			if distance < last_distance:
				min_pos = r				
		action.change_target(min_pos)
		# 之后要添加障碍检测
		action.execute()
