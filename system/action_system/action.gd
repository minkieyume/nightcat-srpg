class_name Action
extends Resource
# 行动的基类

@export var id:StringName = &"action"
@export var action_name:String = "行动" #显示名字
@export var action_range:ActionRange
@export var allowed_target = { #允许执行行动的目标。
	"Tile":true,   # 图块
	"Enemy":true,  # 敌人
	"Player":true, # 玩家
	"Object":true  # 物件
}

func _init() -> void:
	id = &"action"

func execute(character:Character,target:Vector2i) -> bool:
	#执行action的行动，成功返回true
	print(character.name,target)
	return true
