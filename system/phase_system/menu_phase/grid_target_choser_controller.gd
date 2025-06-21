extends MenuPhase

var grid_drawer:GridDrawer

"""Transition：
&"character_chose" -> action_choser
&"action_target_chose" -> action_achiever
"""

"""上下文：
target:Vector2i 选中的目标，通常是一个坐标。
target_chose_event:StringName TargetChoser选中后触发的事件，决定接下来转换到哪个节点
chosed_action: ActionChoser选中的行动。
"""

func _ready() -> void:
	super()
	add_event_handler("chose",_chose)

func _setup() -> void:
	grid_drawer = level_handler.get_grid_drawer()

func _enter() -> void:
	super()
	grid_drawer.show_highlight = true
	# 限制移动范围：只允许AP步数内的格子
	var actor_id = context.get("actor", null)
	var action_id = context.get("chosed_action", null)
	if typeof(actor_id) == TYPE_INT and action_id == &"move":
		var actor = level_handler.get_character(actor_id)
		if actor:
			var ap = actor.get_ap()
			var start = level_handler.get_character_position(actor_id)
			# 获取所有AP步数内可达格子
			var grid_map = level_handler.get_grid_map()
			var reachable = []
			# 简单BFS遍历所有可达且步数<=ap的格子
			var visited = {}
			var queue = [{"pos": start, "step": 0}]
			while queue.size() > 0:
				var node = queue.pop_front()
				var pos = node["pos"]
				var step = node["step"]
				if visited.has(pos):
					continue
				visited[pos] = true
				if step > ap:
					continue
				reachable.append(pos)
				for dir in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
					var next = pos + dir
					if !grid_map.is_cell_block(next):
						queue.append({"pos": next, "step": step + 1})
			# 类型安全赋值，避免Godot 4.x类型报错
			grid_drawer.limit_array.clear()
			grid_drawer.limit_array.append_array(reachable)
			grid_drawer.show_limit = true
	else:
		grid_drawer.limit_array = []
		grid_drawer.show_limit = false

func _exit() -> void:
	super()
	grid_drawer.show_highlight = false

func _chose() -> bool:
	context["target"] = get_chosed_target()
	dispatch(context["target_chose_event"])
	return true

func update_target_position(new_pos:Vector2i):
	# 只允许高亮在limit_array内
	if grid_drawer.show_limit and grid_drawer.limit_array.size() > 0:
		if new_pos in grid_drawer.limit_array:
			grid_drawer.highlight = new_pos
			return
		# 若不在范围内，自动选最近的可选格
		var min_dist = INF
		var best = grid_drawer.highlight
		for pos in grid_drawer.limit_array:
			var d = pos.distance_to(new_pos)
			if d < min_dist:
				min_dist = d
				best = pos
		grid_drawer.highlight = best
	else:
		grid_drawer.highlight = new_pos

func get_chosed_target() -> Vector2i:
	# 只允许选择limit_array内的格
	if grid_drawer.show_limit and grid_drawer.limit_array.size() > 0:
		if grid_drawer.highlight in grid_drawer.limit_array:
			return grid_drawer.highlight
		# fallback
		return grid_drawer.limit_array[0]
	return grid_drawer.highlight

func _return(cargo:Dictionary) -> bool:
	return true

func _on_target_chosed():
	dispatch("chose")

func _on_target_canceled():
	dispatch("_return")
