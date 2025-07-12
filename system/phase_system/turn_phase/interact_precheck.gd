extends Phase

func _enter():
	super()
	match context["mode"]:
		"before_interact":
			var iid = context["interactable"]
			var interactable = LevelHandler.get_unit(iid)
			if !interactable.is_in_group("interactable"):
				if !interactable.is_in_group("interactable"):
					print("互动失败，不在组内")
					quit()
			var presult = await interactable.precheck
			if presult:
				context["mode"] = "before_interact"
				call_deferred("dispatch","next")
			else:
				print("互动预检查失败")				
				quit()

func _exit():
	super()

func quit():
	context.erase("actor")
	context.erase("interactable")
	context.erase("target")
	call_deferred("dispatch","failed")
