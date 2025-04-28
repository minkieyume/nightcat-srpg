class_name ActionResource
extends Resource
# 行动的基础资源

@export var id:StringName = &"action"
@export var group:String = "" #行动选单中的分组，为空代表根组，支持/分隔子组。
@export var action_name:String = "行动" #显示名字
@export var action_range:ActionRange
@export var action_logic:GDScript
@export var allowed_target = { #允许执行行动的目标。
	"Tile":true,   # 图块
	"Enemy":true,  # 敌人
	"Player":true, # 玩家
	"Object":true  # 物件
}
