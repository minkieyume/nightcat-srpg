extends Level

@onready var characters = $Characters
@onready var grid_map:TileMapLayer =  $GridMap
@onready var camera:PhantomCamera2D = $PhantomCamera2D
@onready var grid_drawer:GridDrawer = $GridDrawer
@onready var grid_quester:GridQuester = $GridQuester
@onready var movement_server:MovementServer = $MovementServer
@onready var objects = $Objects

func _ready() -> void:
	var character_dict = pack_nodes_to_dict(characters)
	var object_dict = pack_nodes_to_dict(objects)
	unit_dict.merge(character_dict)
	unit_dict.merge(object_dict)
	super()
	

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

func get_camera() -> PhantomCamera2D:
	return camera
