extends Level

var character_list:Array[Character]

@onready var characters = $Characters
@onready var grid_map:TileMapLayer =  $GridMap
@onready var grid_drawer:GridDrawer = $GridDrawer

func _ready() -> void:
	super()
	character_list = pack_nodes(characters,character_list)

func get_grid_drawer() -> GridDrawer:
	return grid_drawer

func get_grid_map() -> TileMapLayer:
	return grid_map

func get_character_list() -> Array[Character]:
	return character_list

func get_character(id:int):
	return character_list[id]
