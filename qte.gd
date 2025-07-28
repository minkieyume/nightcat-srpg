extends MenuPhase

# 上下文："qte_result":int

func apply_qte_result(result:int):
	context["qte_result"] = result
	call_deferred("dispatch","hide")
