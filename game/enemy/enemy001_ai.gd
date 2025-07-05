extends StateAI

@onready var patrol = $Patrol
@onready var stop = $Stop
@onready var chase = $Chase

func _init_ai():
	add_transition(patrol,stop,"stop")
	add_transition(chase, stop,"stop")
	add_transition(stop, patrol,"end_stop")
	add_transition(patrol, chase,"find_enemy")
	add_transition(chase, patrol,"lost_enemy")
	initialize(get_parent())
	set_active(true)
