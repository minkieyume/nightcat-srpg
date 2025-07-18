class_name ActionResource
extends Resource
## 行动的基础资源

@export var id:StringName = &"action"
@export var group:String = "" #行动选单中的分组，为空代表根组，支持/分隔子组。
@export var action_name:String = "行动" #显示名字
@export var action_range:ActionRange
@export var action_logic:GDScript
# @export var allowed_target = { #允许执行行动的目标。
# 	"Tile":true,   # 图块
# 	"Enemy":true,  # 敌人
# 	"Player":true, # 玩家
# 	"Object":true  # 物件
# }
@export var args:Dictionary
## 行动消耗AP
@export var ap_cost: int = 1
## 一回合的最大行动次数
@export var max_twice: int = 1
@export var tags:Array[String]
## 一回合的目前行动计次
var twice = 0
#@export var cooldown: int = 0 # 行动冷却回合数
#@export var icon: Texture2D # 行动图标（可选）
#@export var effect_fx: PackedScene # 行动特效（可选）

func has_tag(tag:String) -> bool:
	return tag in tags

func any_tags(atags:Array) -> bool:
	return atags.any(func(t:String):return has_tag(t))

func all_tags(atags:Array) -> bool:
	return atags.all(func(t:String):return has_tag(t))

func count_twice():
	twice +=1

func reset_twice():
	twice = 0

func is_twice_max():
	return twice>=max_twice
