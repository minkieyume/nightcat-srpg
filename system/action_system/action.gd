class_name Action
extends Object

var level_handler:LevelHandler
var requester:String
var target:Vector2i

var resource:ActionResource
var action_range:ActionRange
var logic:ActionLogic


signal failed
signal finished

func execute()  -> bool:
	if is_instance_valid(action_range):
#		print("[Action]",requester)
		var result = clac_action_range()
		if !is_target_valid(result):
			emit_signal("failed")
			return false
	var action_result = await logic.execute(requester,target,level_handler)
	if !action_result:
		emit_signal("failed")
		return false
	emit_signal("finished")
	return true

func set_target(t:Vector2i):
	target = t

## 计算允许互动的绝对坐标。
func clac_action_range() -> Array[Vector2i]:
	var origin = level_handler.get_character_position(requester)	

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
