extends LimboState

func _setup() -> void:
	agent.direction_changed.connect(_on_direction_changed)

func _enter() -> void:
	_update_animation(agent.direction)

func _update_animation(direction) -> void:
	match direction:
		Vector2i.DOWN:
			if agent.animation_player.has_animation("idle/idle_down"):
				agent.animation_player.play("idle/idle_down")
		Vector2i.LEFT:
			if agent.animation_player.has_animation("idle/idle_left"):
				agent.animation_player.play("idle/idle_left")
		Vector2i.RIGHT:
			if agent.animation_player.has_animation("idle/idle_right"):
				agent.animation_player.play("idle/idle_right")
		Vector2i.UP:
			if agent.animation_player.has_animation("idle/idle_up"):
				agent.animation_player.play("idle/idle_up")

func _on_direction_changed(direction):
	if is_active():
		_update_animation(direction)
