extends Phase

var interactable:Interactable

func _enter():
	super()
	#print(context)
	var iid = context["interactable"]
	interactable = level_handler.get_interactable(iid)
	interactable.finished.connect(_on_interactable_finished)
	if context.has("mode"):
		if context["mode"] == "before_interact":
			interactable.before_interact(context["actor"],level_handler)
			#print("before")
		elif context["mode"] == "interact":
			var ctx = Dictionary()
			ctx["target"] = context["target"]
			interactable.interact(context["actor"],level_handler,ctx)
	
func _exit():
	super()
	if !context.has("mode") or context["mode"] != "interact":
		quit()

func quit():
	context.erase("interactable")
	context.erase("target")
	interactable.finished.disconnect(_on_interactable_finished)
	interactable = null

func _on_interactable_finished():
	pass

func _on_level_handler_command_send(command:StringName, args:Array) -> void:
	if command == "setcargo":
		if context.has("mode"):
			if context["mode"] == "befor_interact":
				context[args[0]] = context[args[1]]
	if command == "chose_target":
		#print(context)
		context["mode"] = "interact"
		context["target_chose_event"] = "interactable_target_chose"
		dispatch("chose_target")
