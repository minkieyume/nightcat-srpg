extends PhaseMenu

var action_button_groups:Dictionary
var current_button_groups:Dictionary
var current_action_buttons:Dictionary

@onready var action_button = $ActionButton
@onready var grid_container = $Panel/GridContainer
@onready var panel = $Panel

func _ready() -> void:
	super()
	phase.context_updated.connect(_on_phase_context_updated)

func _on_phase_context_updated(id,content):
	if id == "action_list":
		if content == null or content.size() == 0:
			push_warning("[action_choser.gd] 收到空的 action_list，UI不会显示任何按钮。请检查角色是否配置了可用技能/行动资源。")
		update_action_button_groups(content)
		update_action_buttons("")
		# 自动刷新角色AP信息
		var actor_id = phase.context.get("actor", null)
		if typeof(actor_id) == TYPE_INT:
			var actor = phase.level_handler.get_character(actor_id)
			if actor and actor.has_method("get_ap"):
				var ap = actor.get_ap()
				var max_ap = actor.get_attribute("max_ap")
				var char_info = get_tree().get_root().find_child("CharacterInfo", true, false)
				if char_info:
					char_info.set_ap(ap, max_ap)
				# 监听AP变化，动态刷新
				if actor:
					# 断开旧信号再连接，避免重复
					if actor.is_connected("ap_changed", Callable(char_info, "set_ap")):
						actor.disconnect("ap_changed", Callable(char_info, "set_ap"))
					actor.connect("ap_changed", Callable(char_info, "set_ap").bind(max_ap))

func update_action_button_groups(action_list:Dictionary):
	action_button_groups.clear()
	if action_list == null or action_list.size() == 0:
		push_warning("[action_choser.gd] 收到空的 action_list，无法生成按钮。")
		return
	for id in action_list.keys():
		var action_res:ActionResource = action_list[id]
		if action_res == null:
			push_warning("[action_choser.gd] action_list[%s] 为空，跳过。" % [str(id)])
			continue
		var sub_group = pull_subaction_group(action_res.group)
		create_action_button(id,action_res.action_name,action_button,sub_group)

func create_action_button(id:StringName,action_name:StringName,sample_button:Button,action_dict:Dictionary):
	# 在指定组中创建按钮。
	var button:Button = sample_button.duplicate()
	var action_res:ActionResource = null
	# 查找对应的 ActionResource
	for group in action_button_groups.values():
		if id in group:
			action_res = group[id]
	if action_res == null:
		# 兼容旧逻辑
		action_res = phase.context["action_list"].get(id, null)
	# 拼接显示AP/冷却
	var ap_str = "AP:" + str(action_res.ap_cost)
	var cd_str = ""
	if action_res.cooldown > 0:
		cd_str = "/冷却:" + str(action_res.cooldown)
	button.text = action_name + " [" + ap_str + cd_str + "]"
	# 判断可用性
	var actor_id = phase.context.get("actor", null)
	var actor = null
	if typeof(actor_id) == TYPE_STRING:
		actor = phase.level_handler.get_character(actor_id)
	if actor == null or actor.action_manager == null:
		push_error("[action_choser.gd] context['actor'] 不是合法角色对象，缺少 action_manager。当前值：%s" % [str(actor_id)])
		return
	var am = actor.action_manager
	var can_use = true
	if am and am.has_method("can_execute_action"):
		can_use = am.can_execute_action(id, actor)
	if !can_use:
		button.disabled = true
	else:
		button.disabled = false

	action_dict[id] = button

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
		current_action_buttons[button] = id
		grid_container.add_child(button)
		button.pressed.connect(_on_action_button_pressed)
		button.visible = true
	grid_container.get_child(0).grab_focus()

func _on_action_button_pressed():
	var button = get_viewport().gui_get_focus_owner()
	if button is Button:
		var id = current_action_buttons[button]
		var button_group = current_button_groups[id]
		if button_group is Dictionary:
			update_action_buttons(id)
		else:
			phase.update_context("chosed_action",id)
			phase.dispatch("action_chosed")
