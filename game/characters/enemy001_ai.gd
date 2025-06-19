extends StateAI


@onready var patrol = $Patrol
@onready var guard = $Guard
@onready var chase = $Chase

func _init_ai():
	add_transition(patrol,guard,"stop_patrol")
	add_transition(guard, chase,"find_enemy")
	add_transition(chase, patrol,"lost_enemy")
	initialize(get_parent())
	set_active(true)
	print(agent)
