extends Node

var agents = {}
var agent_ready = false
signal agent_readed

func is_online():
	return MPIO.mpc.mode == MPIO.mpc.PlayMode.Online

@rpc("any_peer","call_local")
func set_agent(ap:NodePath):
	var a = get_node(ap)
	var id:int = a.mpp.player_id	
	agents["%d"%id] = a
	agent_ready = true
	emit_signal("agent_readed")

func get_agents() -> Dictionary:
	return agents
