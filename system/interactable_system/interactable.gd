class_name Interactable
## 这是一个接口类
## 要实现该类，只需要实现该类的全部方法，并添加interactable的组即可。
## 也可以直接继承本类，虽然一般不建议这么做
extends Unit


signal finished
signal failed

## 互动前的操作 
func before_interact(character:String,handler:LevelHandler):
	print(character)

## 与物体互动
func interact(character:String,handler:LevelHandler,ctx:Dictionary):
	print(character)
