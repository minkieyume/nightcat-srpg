extends MenuState

"""Transition：
"chose_target" -> grid_target_choser
"""

"""上下文：
target:Vector2i TargetChoser选中的目标，通常是一个坐标。
target_chose_event:StringName TargetChoser选中后触发的事件，决定转换到哪个节点。
action_target:Character 行动目标所指向的角色。
"""

var action_button_groups:Dictionary
var current_action_buttons:Dictionary

@onready var action_button = $ActionButton
@onready var grid_container = $Panel/GridContainer
@onready var panel = $Panel

signal quest_character(quester:Node,target:Vector2i)

func _ready() -> void:
	super()

func _enter() -> void:
	super()
	emit_signal("quest_character",self,context["target"])

func _on_action_chosed():
	context["action"] = "move"

func get_grid_result(result):
	if result is Character:
		context["action_target"] = result
		_update_action_button_groups()
		update_action_buttons("")

func _update_action_button_groups():
	action_button_groups.clear()
	var action_list = context["action_target"].get_action_list()
	for id in action_list.keys():
		var action_res:ActionResource = action_list[id]
		var sub_group = get_subaction_group(action_res.group)
		create_action_button(id,action_res.action_name,action_button,sub_group)

func create_action_button(id:StringName,action_name:StringName,sample_button:Button,action_dict:Dictionary):
	# 在制定组中创建按钮。
	var button:Button = sample_button.duplicate()
	button.text = action_name
	action_dict[id] = button

func get_subaction_group(group:String) -> Dictionary:
	# 根据group解析并获取按钮组，如果该组不存在则自动创建。
	var upgroup:Dictionary = action_button_groups
	if group == "":
		return upgroup
	for id in group.split("/"):
		if !upgroup.has(id):
			upgroup[id] = {}
		upgroup = upgroup[id]
	return upgroup

func update_action_buttons(group:String):
	# 更新并展示特定组的按钮
	var subgroup = get_subaction_group(group)
	current_action_buttons.clear()
	for button in grid_container.get_children():
		if button is Button:
			button.visible = false
			button.pressed.disconnect(_on_action_button_pressed)
			grid_container.remove_child(button)

	for id in subgroup:
		var button = subgroup[id]
		if !button is Button:
			button = action_button.duplicate()
			button.text = id
		current_action_buttons[button] = id
		grid_container.add_child(button)
		button.pressed.connect(_on_action_button_pressed)
		button.visible = true
	grid_container.get_child(0).grab_focus()

func _on_action_button_pressed():
	var button = get_viewport().gui_get_focus_owner()
	if button is Button:
		var id = current_action_buttons[button]
