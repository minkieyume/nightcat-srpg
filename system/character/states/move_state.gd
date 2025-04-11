extends LimboState

func _setup() -> void:
	agent.direction_changed.connect(_on_direction_changed)

func _enter() -> void:
	_update_animation(agent.direction)
	walk_path()

func _update_animation(direction) -> void:
	match direction:
		Vector2i.DOWN:
			agent.animation_player.play("move/move_down")
		Vector2i.LEFT:
			agent.animation_player.play("move/move_left")
		Vector2i.RIGHT:
			agent.animation_player.play("move/move_right")
		Vector2i.UP:
			agent.animation_player.play("move/move_up")

func _on_direction_changed(direction):
	if is_active():
		_update_animation(direction)

func walk_path():
	var path = agent.move_path
	var map = agent.space_tilemap
	for point in path:
		var start = map.local_to_map(agent.position)
		await step(point - start)
	get_root().dispatch("move_stop")
	

func step(dir:Vector2i) -> void:
	# 朝特定方向移动一格
	agent.change_direction(dir)
	var map = agent.space_tilemap
	var end = agent.position+Vector2(map.tile_set.tile_size)*Vector2(dir)
	var dis = agent.position.distance_to(end)
	var tween = get_tree().create_tween()
	tween.tween_property(agent,"position",end,dis/agent.move_speed)
	await tween.finished
	
func _update(_delta: float) -> void:
	pass
