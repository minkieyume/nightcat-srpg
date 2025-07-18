extends Node

## 根据剩余AP，从行动列表中随机选取一个可执行动执行。
## 如果没有指定过滤器，默认为标签带有attack的行动
func random_chose_action(agent:Node,target:Vector2i,\
	filter:Callable=func(a:ActionResource):return a.has_tag("attack")):
	var ap = agent.get_ap()
	var action_manager:ActionManager = agent.action_manager
	var chosed_actions = action_manager.get_action_id_list(filter)
	var actions = []

	# 从行动中过滤出AP及行动次数不足的行动，并批量执行预检查
	for actid in chosed_actions:
		var actrs = action_manager.get_action_resouce(actid)
		var action_ap  = actrs.ap_cost
		if ap >= action_ap and actrs.twice>0:
			var action = Action.new(agent.id,actid)
			await action.before_target_chose()
			action.set_target(target)
			if await action.precheck():
				actions.append(actid)
	
	# 随机选择行动
	if actions.size() > 0:
		var rand_acton_index = randi()%(actions.size())
		var action_id = actions[rand_acton_index-1]
		return action_manager.get_action_resouce(action_id)
	return null

## 根据给定的过滤器，获取特定单位在agent的行动范围内的行动列表。
## 具体的判定方式依赖行动的预检查机制判定。
## 如果没有指定过滤器，默认为标签带有attack的行动
func get_action_unit_in_range(unit_id:String,agent:Node,\
	filter:Callable=func(a:ActionResource):return a.has_tag("attack")) -> Array:
	var action_manager:ActionManager = agent.action_manager
	var chosed_actions = action_manager.get_action_id_list(filter)
	var actions = []	
	var target = LevelHandler.get_unit_position(unit_id)

	for actid in chosed_actions:
		var action = Action.new(agent.id,actid)
		await action.before_target_chose()
		action.set_target(target)
		if await action.precheck():
			actions.append(actid)	
	return actions

## 根据给定的过滤器，判断特定单位是否在agent的行动列表的任一行动范围内。
## 如果没有指定过滤器，默认为标签带有attack的行动
func is_unit_in_action_range(unit:String,agent:Node,\
	filter:Callable=func(a:ActionResource):return a.has_tag("attack")) -> bool:
	var actions = await get_action_unit_in_range(unit,agent,filter)
	return actions.is_empty()

## 获取移动到与角色保持给定距离的动作。
func get_move_near_character_action(agent:Node,dis:int=1,manhattan:=false):
	var grid_quester = LevelHandler.get_grid_quester()
	var server = LevelHandler.get_movement_server()
	var origin = LevelHandler.get_unit_position(agent.id)

	var action = Action.new(agent.id,&"move")
	await action.before_target_chose()

	# 获取距离自身最近的玩家的最近临近格
	var sight_radius = grid_quester.quest_tiles_in_sight(origin,agent.sector)
	var characters = grid_quester.quest_character_in_area(sight_radius).\
		filter(func(c):return LevelHandler.is_unit_in_group(c.id,"player"))
	var nearst_target = null
	for character in characters:
		var near_target:Vector2i
		if manhattan:
			near_target = \
				grid_quester.quest_tiles_distance_unit_manhattan(character.id,dis)\
				.filter(func(p):return server.is_point_reachable(agent.id,p))\
					.reduce(func(c1,c2):return get_near_pos(agent,c1,c2))
		else:
			near_target = grid_quester.quest_tiles_distance_unit(character.id,dis)\
				.filter(func(p):return server.is_point_reachable(agent.id,p))\
					.reduce(func(c1,c2):return get_near_pos(agent,c1,c2))
		if near_target != null:
			if nearst_target == null:
				nearst_target = near_target
			else:
				nearst_target = get_near_pos(agent,near_target,nearst_target)

	if nearst_target == null:
		return null
	
	# 获取行动的限制范围，并选择限制范围中最接近该玩家的最近临近格的格子。
	var limit_array = action.clac_action_range()
	var target = null
	for target_pos in limit_array:
		if server.is_point_reachable(agent.id,target_pos):
			if target == null:
				target = target_pos
			elif target.distance_to(nearst_target) > target_pos.distance_to(nearst_target):
				target = target_pos
	
	if target != null:
		action.set_target(target)
		return action
	else:
		return null

func get_near_pos(agent:Node,c1:Vector2i,c2:Vector2i):
	var origin:Vector2i = LevelHandler.get_unit_position(agent.id)
	if origin.distance_to(c1) < origin.distance_to(c2):
		return c1
	else:
		return c2

## 更新朝向面向玩家
func update_face_to_character(agent:Node):
	var grid_quester = LevelHandler.get_grid_quester()
	var origin = LevelHandler.get_unit_position(agent.id)
	var c_pos = agent.in_sight_units.\
		filter(func(c):return LevelHandler.is_unit_in_group(c,"player")).\
		map(func(c):return LevelHandler.get_unit_position(c)).\
		reduce(func(c1,c2):return get_near_pos(agent,c1,c2))
	if c_pos:
		var dir = grid_quester.quest_related_direction(origin,c_pos)
		agent.change_direction(dir)
		agent.update_sight_face(dir)
		agent.update_sight_view()
