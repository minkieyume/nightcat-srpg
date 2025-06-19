extends Phase

"""上下文：
master:String 角色拥有者的ID
target:Vector2i 选中的目标，通常是一个坐标。
target_chose_event:StringName TargetChoser选中后触发的事件，决定接下来转换到哪个节点
chosed_action: ActionChoser选中的行动。
"""

func _enter() -> void:
	var owne:CharacterOwner = level_handler.get_character_owner(context["master"])
	for cid in owne.handled_characters:
		var character = level_handler.get_character(cid)
		if character.is_in_group("ai_character"):
			var ai:StateAI = character.ai
			ai.run_current_state(level_handler)
	dispatch("next")
