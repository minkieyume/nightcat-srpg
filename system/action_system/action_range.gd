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
