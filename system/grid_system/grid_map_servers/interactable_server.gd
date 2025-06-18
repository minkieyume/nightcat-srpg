extends GridMapServer
# 处理角色与interactable的互动请求
# Action与Interactable的桥梁

@export var grid_quester:GridQuester

func _on_command_recieved(command:StringName,args:Array):
	if command == "interact_interactable":
		var id = grid_quester.quest_interactable(args[1])
		if id != "":
			var interactable = level_handler.get_interactable(id)
			interactable.interact(args[0],level_handler)
