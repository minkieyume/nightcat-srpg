extends Level

@onready var characters = $Characters
@onready var grid_map:TileMapLayer =  $TileMapLayer
@onready var grid_drawer:GridDrawer = $GridDrawer
@onready var grid_quester:GridQuester = $GridQuester
@onready var movement_server:MovementServer = $MovementServer
@onready var objects = $Objects

func _ready() -> void:
	super()
	var character_dict = pack_nodes_to_dict(characters)
	var object_dict = pack_nodes_to_dict(objects)
	unit_dict.merge(character_dict)
	unit_dict.merge(object_dict)

func get_grid_drawer() -> GridDrawer:
	return grid_drawer

func get_grid_map() -> TileMapLayer:
	return grid_map

func get_grid_map_layers() -> Array[GridMapLayer]:
	return [grid_map]

func get_grid_quester() -> GridQuester:
	return grid_quester

func get_movement_server() -> MovementServer:
	return movement_server
