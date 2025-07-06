class_name Interactable
extends Node2D
## Interactable的接口类
## 要实现该类，只需要实现该类的全部方法，并添加interactable的组即可。

@export var id = "interactable1"

# 与物体互动
func interact(character:String,handler:LevelHandler):
	print(character)
