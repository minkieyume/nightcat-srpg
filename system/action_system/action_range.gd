class_name ActionRange
extends Resource

@export var deter_array:Array[Vector2i]
@export var deter_vector2:Vector2i
@export var deter_rect2:Rect2i
## 根据判定类别的不同，输入参数也有所不同。
# 数组: 直接在deter_array输入绝对坐标的数组集判定。
# 相对：直接deter_array输入相对坐标的数组集。
# 距离：在deter_vertor2输入一个Vector2i变量，x为最小距离，y为最大距离。
# 范围：在deter_vertor2输入一个Vector2i变量，x为长，y为宽。
# 矩形：在deter_rect2输入一个Rect2i变量判定。

@export_enum("数组","相对","距离","范围","矩形") var type = 0
## 可行动范围的判定类别
# 数组: 原始的判定方式，直接用绝对坐标的数组集判定。
# 相对：用一组包含相对原点的Vector2i坐标的数组来判定。
# 距离：根据原点到行动目标的格数判定。
# 范围：根据行动目标是否在以原点为中心的特定矩形范围内判定。
# 矩形：直接相对角色的矩形变量来判定。

var result:Array[Vector2i] # 当前判定的结果，为一组绝对坐标。

func clac_result(origin:Vector2i) -> Array[Vector2i]:
	# 根据输入参数将允许互动的绝对坐标计算出来。
	var _result:Array[Vector2i] = []
	match type:
		0:
			_result = deter_array
			result = _result
			return _result
		1:
			for local in deter_array:
				_result.append(origin+local)
			result = _result
			return _result
		2:
			var min_range = deter_vector2.x
			var max_range = deter_vector2.y
			var cx = origin.x
			var cy = origin.y
			for dx in range(-max_range, max_range + 1):
				for dy in range(-max_range, max_range + 1):
					var dist = abs(dx) + abs(dy)
					if dist >= min_range and dist <= max_range:
						_result.append(Vector2i(cx + dx, cy + dy))
			result = _result
			return _result
		3:
			var w:float = float(deter_vector2.x)
			var h:float = float(deter_vector2.y)
			var wl = floori(w/2)
			var hl = floori(h/2)
			var d_rect = Rect2i(Vector2i(-wl,-hl),deter_vector2)
			_result = _clac_rect_result(origin,d_rect)
			result = _result
			return _result
		4:
			_result = _clac_rect_result(origin,deter_rect2)
			result = _result
			return _result
		_:
			return _result

func _clac_rect_result(origin:Vector2i,rect:Rect2i) -> Array[Vector2i]:
	var _result = []
	var min_rand = origin+rect.position
	var max_rand = origin+rect.end
	for px in range(min_rand.x,max_rand.x+1):
		for py in range(min_rand.y,max_rand.y+1):
			_result.append(Vector2i(px,py))
	return _result

func is_target_valid(target:Vector2i) -> bool:
	if target in result:
		return true
	else:
		return false
