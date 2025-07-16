class_name Buff
extends Resource
## 回合制的buff

## buff的识别id
@export var id = "name"

## buff用于修饰属性的效果Buff
@export var attribute_buff:AttributeBuff

# ## Buff持续的回合数，为0会在回合结束时移除。
# ## 需要阶段管理器配合。
# @export var tick:int = 1

@export var buff_logic:GDScript
