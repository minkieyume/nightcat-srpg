extends StateAIState

func _state_logic(handler:LevelHandler):
	var players = handler.get_player_list()
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

	# 获取要移动到的目标坐标
	var prechose_target = []	
	prechose_target.append(min_pos+Vector2i.LEFT)
	prechose_target.append(min_pos+Vector2i.DOWN)
	prechose_target.append(min_pos+Vector2i.RIGHT)
	prechose_target.append(min_pos+Vector2i.UP)

	min_pos = prechose_target.min()

	for target in prechose_target:
		if self_pos.distance_to(target) < self_pos.distance_to(min_pos):
			min_pos = target
		

	var action:Action = factory.create_action(agent.id,&"move")
	action.set_target(min_pos)
	var rrange = action.clac_action_range()
	if action.is_target_valid(rrange):
		action.execute()
		#临时方案，后面得改成选择最近的没有障碍物的点。
	else:
		# 重设为距离最近的坐标
		var player_pos = min_pos
		min_pos = rrange[0]
		for r in rrange:
			var distance = r.distance_to(player_pos)
			var last_distance = r.distance_to(player_pos)
			if distance < last_distance:
				min_pos = r
				action.change_target(min_pos)
				# 之后要添加障碍检测
		action.execute()

func _transition_precheck(handler:LevelHandler):
	agent.update_sight_character(handler) # 此方法后面移到阶段中最好。
#	var sc:Array = agent.in_sight_characters
#	if sc.is_empty():
#		dispatch("lost_enemy")
		
