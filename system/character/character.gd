class_name Character
# 处理角色状态与行为
# 与各个Server中介通信
extends Unit

@export_category("初始属性")
## 角色权重
@export var weight:int = 0
## 用于初始化修饰角色属性的值。
@export var initalize_attribute_buffs:Array[AttributeBuffBase]

@export_category("视野")
## 默认的视野扇形
@export var sight_sector:TiledSector2D
## 放大视野范围时增加的半径。
@export var sight_expand_radius:int
## 放大视野范围时增加的角度
@export var sight_expand_angle:float

@onready var action_manager = $ActionManager
@onready var attributes = $AttributeContainer
@onready var character_info = $Character_info

var found_units:Dictionary[String,int] = {} # 带有目标权重的角色字典
var in_sight_units:Array[String] = []
var buffs:Dictionary[Buff,int]
var sector:TiledSector2D

# 角色状态管理
#var state: String = "normal" # 角色当前状态，如 normal, stunned, confused 等
#var state_turns: int = 0 # 状态剩余持续回合数

signal ap_changed(new_ap)

func _init_attribute() -> void:
	for buff in initalize_attribute_buffs:
		attributes.apply_buff(buff)

func _init_state_machine() -> void:
	animation_machine.add_transition(idle_state, move_state,"move_start")
	animation_machine.add_transition(move_state, idle_state,"move_stop")
	animation_machine.initialize(self)
	animation_machine.set_active(true)

## 重置视野范围为默认值
func reset_sight():
	sector = sight_sector.duplicate(true)

func expand_sight(turn:int=1):
	var t = turn
	while t > 0:
		sector.radius = sight_expand_radius+sector.radius
		sector.angle = sight_expand_angle+sector.angle
		t = t -1	

func update_sight_face(dir:Vector2i):
	sector.face = dir
	update_sight_view()

func step_path(path:Array[Vector2i],vdis:Vector2,map:TileMapLayer) -> void:
	# 沿着path批量移动
	var start = map.local_to_map(position)
	for point in path:
		await step(point - start,vdis)
		start = map.local_to_map(position)	
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
	for character in LevelHandler.get_characters():
		character.update_sight_units()
		character.found_sights_unit()
	animation_machine.dispatch("move_stop")

## 更新视野内的单位
func update_sight_units():
	in_sight_units = []
	var units = LevelHandler.get_units()
	var quester = LevelHandler.get_grid_quester()
	var origin = LevelHandler.get_unit_position(id)
	for unit in units:
		var pos = LevelHandler.get_unit_position(unit.id)
		if unit.id == id:
			continue
		if quester.is_in_sight(origin,pos,sector):
			in_sight_units.append(unit.id)
		else:
			in_sight_units.erase(unit.id)

## 在发现列表添加单位
func discover_unit(unit:String,wei:int):
	found_units[unit] = wei

## 寻找进入视野的角色并加入发现列表。
## 发现列表默认按距离计算权重，方便AI根据权重判定优先级。
func found_sights_unit():
	var units = LevelHandler.get_unit_ids()
	for unit in units:		
		if unit == id:
			continue
		if unit in in_sight_units and !found_units.has(unit):			
			discover_unit(unit,0)

## 结合距离等因素，计算特定单位的实际权重
func count_unit_weight(unit:String) -> int:
	var wei = found_units[unit]
	var quester = LevelHandler.get_grid_quester()
	var pos = LevelHandler.get_unit_position(unit)
	var origin = LevelHandler.get_unit_position(id)
	var distance = quester.manhattan_distance_to(origin,pos)
	return wei-distance

## 计算所有单位的实际权重并返回一个权重字典。
func count_units_weight() -> Dictionary[String,int]:
	var units = found_units.duplicate()
	for unit in units.keys():		
		units[unit] = count_unit_weight(unit)
	return units

## 让特定单位从发现列表中丢失
func lost_sight_unit(unit:String):
	found_units.erase(unit)

## 显示视野范围高亮范围
func show_sight_view():
	var grid_drawer = LevelHandler.get_grid_drawer()
	var quester = LevelHandler.get_grid_quester()
	var origin = LevelHandler.get_unit_position(id)
	var sights_array = quester.quest_tiles_in_sight(origin,sector)
	grid_drawer.update_sight_dict(id,sights_array)

## 隐藏视野高亮范围
func hide_sight_view():
	var grid_drawer = LevelHandler.get_grid_drawer()
	grid_drawer.clean_sight_dict(id)

## 更新视野高亮范围
func update_sight_view():
	hide_sight_view()
	show_sight_view()
	LevelHandler.get_grid_drawer().update()
	
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

@rpc("authority","call_remote")
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

# 行动相关
@rpc("authority","call_remote")
func reset_action_twice():
	for _id in action_manager.get_action_id_list():
		var action:ActionResource = action_manager.get_action_resouce(_id)
		action.reset_twice()

# Buff相关
@rpc("authority","call_remote")
func apply_buff(buff_id:String,tick:int):
	var buff = BuffR.get_buff(buff_id)
	if buff == null:
		return
	if buff.attribute_buff:		
		attributes.apply_buff(buff.attribute_buff)
	var logic:BuffLogic = buff.buff_logic.new()
	await logic.apply(id,buff)
	buffs.set(buff,tick)

@rpc("authority","call_remote")
func tick_buffs() -> void:
	for buff in buffs.keys():
		var logic:BuffLogic = buff.buff_logic.new()
		await logic.turn(id,buff)
		buffs.set(buff,buffs[buff]-1)

func get_buff_tick(bid:String) -> int:
	if has_buff(bid):
		var buff = BuffR.get_buff(bid)
		if buff == null:
			return 0
		return buffs[buff]
	else:
		return 0

func has_buff(_id:String) -> bool:
	for buff in buffs:
		if buff.id == _id:
			return true
	return false

@rpc("authority","call_remote")
func remove_buff(bid:String):
	if has_buff(bid):
		var buff = BuffR.get_buff(bid)
		if buff == null:
			return
		if buff.attribute_buff:
			attributes.remove_buff(buff.attribute_buff)
		var logic:BuffLogic = buff.buff_logic.new()
		await logic.remove(id,buff)

## 清空全部buff
@rpc("authority","call_remote")
func clear_buff():
	for buff in buffs.keys():
		remove_buff(buff.id)

## 清理失效的buff
@rpc("authority","call_remote")
func clean_buff():
	for buff in buffs.keys():
		if buffs[buff] <= 0:
			remove_buff(buff.id)

func _on_attribute_container_attribute_changed(_attribute:RuntimeAttribute, _previous_value:float, _new_value:float) -> void:
	update_character_info()

func _on_level_ready():
	super()
	_init_attribute()
	operate_attribute("ap",5,5)
	reset_sight()
