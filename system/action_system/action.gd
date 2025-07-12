class_name Action
extends Object

var requester:String
var target:Vector2i

var resource:ActionResource
var action_range:ActionRange
var ap_cost:int
var logic:ActionLogic
var ctx:Dictionary

func _init(r:String,id:StringName):
	var action_resource:ActionResource = LevelHandler.get_character_action(r,id)
	var action_logic:GDScript = action_resource.action_logic
	requester = r
	resource = action_resource
	action_range = action_resource.action_range
	ap_cost = action_resource.ap_cost
	logic = action_logic.new()

static func from_dict(dict:Dictionary) -> Action:
	var action = Action.new(dict["requester"],dict["id"])
	if dict.has("target"):
		action.set_target(dict["target"])
	if dict.has("ctx"):
		action.set_ctx(dict["ctx"])
	if dict.has("ap_cost"):
		action.set_ap_cost(dict["ap_cost"])
	return action

func to_dictionary() -> Dictionary:
	return {
		"id":resource.id,
		"requester":requester,
		"target":target,
		"ap_cost":ap_cost,
		"ctx":ctx
		}

func before_target_chose():
	if !is_instance_valid(logic):
		return
	await logic.before_target_chose(self)

func before_precheck():
	if !is_instance_valid(logic):
		return
	await logic.before_precheck(self)

func precheck() -> bool:
	if !is_instance_valid(logic):
		return false
	if has_range():
		var r = clac_action_range()
		if !is_target_valid(r):
			return false
	if !can_consume():
		return false
	var result = await logic.precheck(self)
	return result

func has_range():
	if is_instance_valid(action_range):
		return true
	else:
		return false

# func before_run():
# 	CommandBus.send_command("gamephase",["wait"])
# 	CommandBus.send_command("gamephase",["setcargo","mode","start_action"])
# 	if !is_instance_valid(logic):
# 		print("[Action] 行动执行失败")
# 		CommandBus.send_command("gamephase",["action_failed"])
# 		return false
# 	var result = await logic.before_run(self)
# 	if result:
# 		CommandBus.send_command("gamephase",["action_sucess"])
# 		return true
# 	else:
# 		print("[Action] 行动执行失败")
# 		CommandBus.send_command("gamephase",["action_failed"])
# 		return false

func execute():
	CommandBus.server_local_command("gamephase",["wait"])
	await logic.execute(self)
	cost_ap()
	end_action()

func end_action() -> void:
	CommandBus.server_local_command("gamephase",["setcargo","mode","end_action"])
	CommandBus.server_local_command("gamephase",["action_finish"])

func set_target(t:Vector2i):
	target = t

func can_consume() -> bool:
	var character = LevelHandler.get_character(requester)
	var consume = ap_cost
	return character.can_consume_ap(consume)

func cost_ap():
	var character = LevelHandler.get_character(requester)
	var consume = ap_cost
	character.consume_ap(consume)

## 计算允许互动的绝对坐标。
func clac_action_range() -> Array[Vector2i]:
	var origin = LevelHandler.get_unit_position(requester)

	var result:Array[Vector2i] = []
	match action_range.type:
		0:
			result = action_range.deter_array
			return result
		1:
			for local in action_range.deter_array:
				result.append(origin+local)
			return result
		2:
			var min_action_range = action_range.deter_vector2.x
			var max_action_range = action_range.deter_vector2.y
			var cx = origin.x
			var cy = origin.y
			for dx in range(-max_action_range, max_action_range + 1):
				for dy in range(-max_action_range, max_action_range + 1):
					var dist = abs(dx) + abs(dy)
					if dist >= min_action_range and dist <= max_action_range:
						result.append(Vector2i(cx + dx, cy + dy))
			return result
		3:
			var w:float = float(action_range.deter_vector2.x)
			var h:float = float(action_range.deter_vector2.y)
			var wl = floori(w/2)
			var hl = floori(h/2)
			var d_rect = Rect2i(Vector2i(-wl,-hl),\
				action_range.deter_vector2)
			result = _clac_action_range_rect(origin,d_rect)			
			return result
		4:
			result = _clac_action_range_rect(origin,\
				action_range.deter_rect2)
			return result
		_:
			return result

func _clac_action_range_rect(origin:Vector2i,rect:Rect2i)\
	-> Array[Vector2i]:
	var result = []
	var min_rand = origin+rect.position
	var max_rand = origin+rect.end
	for px in range(min_rand.x,max_rand.x+1):
		for py in range(min_rand.y,max_rand.y+1):
			result.append(Vector2i(px,py))
	return result

func is_target_valid(result:Array[Vector2i]) -> bool:
	if target in result:
		return true
	else:
		return false

func change_target(t:Vector2i) -> void:
	target = t

func set_ctx(_ctx:Dictionary):
	if ctx != null:
		ctx.merge(_ctx)
	else:
		ctx = _ctx

func set_ap_cost(ap:int):
	ap_cost = ap

func get_ap_cost() -> int:
	return ap_cost

func set_action_range(a_range:ActionRange):
	action_range = a_range
