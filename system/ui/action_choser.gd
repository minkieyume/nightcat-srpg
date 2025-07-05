extends PhaseMenu

## 全局按钮组
var action_button_groups:Dictionary
## 当前的按钮组
var current_button_groups:Dictionary
## 当前的所有按钮
var current_action_buttons:Dictionary
## 当前的按钮组层级路径，为""默认是根目录
var current_button_path = ""

@onready var action_button = $ActionButton
@onready var grid_container = $Panel/GridContainer
@onready var panel = $Panel

## 行动取消时发出该信号。
signal action_canceled

func _ready() -> void:
	super()
	phase.context_updated.connect(_on_phase_context_updated)
	action_canceled.connect(phase._on_ui_canceled)

func _on_phase_context_updated(id,content):
	if id == "action_list":
		update_action_button_groups(content)
		update_action_buttons(current_button_path)

func update_action_button_groups(action_list:Dictionary):
	action_button_groups.clear()
	for id in action_list.keys():
		var action_res:ActionResource = action_list[id]
		var sub_group = pull_subaction_group(action_res.group)
		create_action_button(id,action_res.action_name,action_button,sub_group)

func create_action_button(id:StringName,action_name:StringName,sample_button:Button,action_dict:Dictionary):
	# 在指定组中创建按钮。
	var button:Button = sample_button.duplicate()
	button.text = action_name
	action_dict[id] = button
	button.gui_input.connect(_gui_input)

func pull_subaction_group(group:String) -> Dictionary:
	# 根据group路径解析并获取按钮组，如果该组不存在则自动创建。
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
	var subgroup = pull_subaction_group(group)
	current_button_groups = subgroup
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
			button.gui_input.connect(_gui_input)
		current_action_buttons[button] = id
		grid_container.add_child(button)
		button.pressed.connect(_on_action_button_pressed)
		button.visible = true
	grid_container.get_child(0).grab_focus()

func _gui_input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		# 根据情况决定是返回上页ui还是返回上个菜单
		print("action_canceled")
		if current_button_path != "":
			var button_groups = Array(current_button_path.split("/"))
			button_groups.pop_back()
			if !button_groups.is_empty():
				var last_id = button_groups.join("/")
				current_button_path = last_id
			else:
				current_button_path = ""
			update_action_buttons(current_button_path)
		else:
			emit_signal("action_canceled")

func _on_action_button_pressed():
	var button = get_viewport().gui_get_focus_owner()
	if button is Button:
		var id = current_action_buttons[button]
		var button_group = current_button_groups[id]
		if button_group is Dictionary:
			current_button_path = id
			update_action_buttons(id)
		else:
			phase.update_context("chosed_action",id)
			phase.dispatch("action_chosed")
