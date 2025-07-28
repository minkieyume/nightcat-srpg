extends MenuPhase

# 上下文："qte_result":int

signal qte_finish

func apply_qte_result(result:int):
	context["qte_result"] = result
	if context.has("_action"):
		var action:Action = context["_action"]
		action.set_ctx(context)
	rpc("remote_qte_finish")
	emit_signal("qte_finish")
	dispatch("hide")	

@rpc("any_peer","call_remote")
func remote_qte_finish():
	emit_signal("qte_finish")
