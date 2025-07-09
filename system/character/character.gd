class_name Character
# 处理角色状态与行为
# 与各个Server中介通信
extends Unit

@export var weight:int = 0

## 用于初始化修饰角色属性的值。
@export var initalize_attribute_buffs:Array[AttributeBuffBase]

@export var sight_sector:TiledSector2D

@onready var action_manager = $ActionManager
@onready var attributes = $AttributeContainer
@onready var character_info = $Character_info

var in_sight_units = []

# 角色状态管理
#var state: String = "normal" # 角色当前状态，如 normal, stunned, confused 等
#var state_turns: int = 0 # 状态剩余持续回合数

signal sight_updated(id:String)
signal ap_changed(new_ap)

func _ready() -> void:
	await super()	
	_init_attribute()
	operate_attribute("ap",5,5)	

func _init_attribute() -> void:
	for buff in initalize_attribute_buffs:
		attributes.apply_buff(buff)
	

func _init_state_machine() -> void:
	animation_machine.add_transition(idle_state, move_state,"move_start")
	animation_machine.add_transition(move_state, idle_state,"move_stop")
	animation_machine.initialize(self)
	animation_machine.set_active(true)

func change_face(face:String) -> bool:
	match face:
		"down":
			change_direction(Vector2i.DOWN)
		"left":
			change_direction(Vector2i.LEFT)
		"right":
			change_direction(Vector2i.RIGHT)
		"up":
			change_direction(Vector2i.UP)
		_:
			return false
	emit_signal("sight_updated",id)
	return true

func change_direction(dir:Vector2i) -> bool:
	if direction == dir:
		return true
	match dir:
		Vector2i.DOWN:
			direction = dir
			sight_sector.face = dir
			return true
		Vector2i.LEFT:
			direction = dir
			sight_sector.face = dir
			return true
		Vector2i.RIGHT:
			direction = dir
			sight_sector.face = dir
			return true
		Vector2i.UP:
			direction = dir
			sight_sector.face = dir
			return true
		_:
			return false	

func step_path(path:Array[Vector2i],vdis:Vector2,map:TileMapLayer) -> void:
	# 沿着path批量移动
	var start = map.local_to_map(position)
	for point in path:
		await step(point - start,vdis)
		start = map.local_to_map(position)
	emit_signal("sight_updated",id)
	emit_signal("path_end")

func step(dir:Vector2,vdis:Vector2) -> void:
	# 朝特定方向移动一段距离
	# dir:朝向的向量
	# vdis:距离的向量，x和y分别代表x方向和y方向的移动量。
	animation_machine.dispatch("move_start")
	change_direction(dir)
	var end = position+vdis*dir
	var dis = position.distance_to(end) # 计算绝对距离数值。
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",end,dis/move_speed)
	await tween.finished
	animation_machine.dispatch("move_stop")

func update_sight_units():
	var units = LevelHandler.get_units()
	var quester = LevelHandler.get_grid_quester()
	var origin = LevelHandler.get_unit_position(id)
	for unit in units:
		var pos = LevelHandler.get_unit_position(unit.id)
		if quester.is_in_sight(origin,pos,sight_sector):
			in_sight_units.append(unit)
		else:
			in_sight_units.erase(unit)

## 显示视野范围高亮范围
func show_sight_view():
	var grid_drawer = LevelHandler.get_grid_drawer()
	var quester = LevelHandler.get_grid_quester()
	var origin = LevelHandler.get_unit_position(id)
	var sights_array = quester.quest_tiles_in_sight(origin,sight_sector)
	print(sights_array)
	grid_drawer.update_sight_dict(id,sights_array)

## 隐藏视野高亮范围
func hide_sight_view():
	var grid_drawer = LevelHandler.get_grid_drawer()
	grid_drawer.clean_sight_dict(id)

# 角色行动
func get_action_list() -> Dictionary:
	return action_manager.action_list

func get_action_resource(aid:StringName):
	return action_manager.get_action_resouce(aid)


# 角色属性
func get_attribute(attr_name: String) -> float:
	return attributes.find_buffed_value(func(attr:RuntimeAttribute): \
		return attr.attribute.attribute_name == attr_name)

## 对Attribute快捷进行操作
## Operation值如下所示：
## 0 - ADD
## 1 - DIVIDE
## 2 - MULTIPLY
## 3 - PERCENTAGE
## 4 - SUBTRACT
## 5 - SET
func operate_attribute(attr_name: String, value:float,o:int=5):
	var buff = AttributeBuff.new()
	var operation = AttributeOperation.new()
	buff.attribute_name = attr_name
	operation.operand = o
	operation.value = value
	buff.operation = operation
	attributes.apply_buff(buff)

func apply_buff(buff:AttributeBuff):	
	attributes.apply_buff(buff)

func update_character_info():
	var ap = int(get_attribute("ap"))
	var hp = int(get_attribute("hp"))
	character_info.text = "AP：%d\nHP：%d"%[ap,hp]

# func add_attribute(attr_name: String, delta):
# 	attributes[attr_name] = get_attribute(attr_name) + delta

# func get_action_manager():
# 	return action_manager

# AP相关
func get_ap() -> int:
	return int(get_attribute("ap"))

func get_max_ap() -> int:
	return int(get_attribute("max_ap"))

func set_ap(value: int) -> void:
	operate_attribute("ap",value,5)
	emit_signal("ap_changed", get_ap())

func add_ap(delta: int) -> void:
	operate_attribute("ap",delta,0)

func reset_ap() -> void:
	set_ap(int(get_attribute("max_ap")))

func can_consume_ap(cost: int) -> bool:
	return get_ap() >= cost

func consume_ap(cost: int) -> bool:
	if can_consume_ap(cost):
		operate_attribute("ap",cost,4)
		return true
	return false

# HP相关
func apply_damage(damage:int):
	operate_attribute("hp",damage,4)

# 状态相关
#func set_state(new_state: String, turns: int = 0) -> void:
#	state = new_state
#	state_turns = turns
#	emit_signal("state_changed", state)
#
#func get_state() -> String:
#	return state
#
#func is_state(state_name: String) -> bool:
#	return state == state_name
#
#func tick_state() -> void:
#	if state != "normal":
#		if state_turns > 0:
#			state_turns -= 1
#			if state_turns == 0:
#				set_state("normal")

#func get_state_turns() -> int:
#	return state_turns


func _on_attribute_container_attribute_changed(_attribute:RuntimeAttribute, _previous_value:float, _new_value:float) -> void:
	update_character_info()
