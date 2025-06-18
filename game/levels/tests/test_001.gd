extends Level

var character_dict:Dictionary[String,Character]
var character_owner_dict:Dictionary[String,CharacterOwner]

@onready var characters = $Characters
@onready var grid_map:TileMapLayer =  $GridMap
@onready var grid_drawer:GridDrawer = $GridDrawer
@onready var character_owners = $CharacterOwners

func _ready() -> void:
	super()
	character_dict = pack_nodes_to_dict(characters,character_dict)
	character_owner_dict = pack_nodes_to_dict(character_owners,character_owner_dict)

func get_grid_drawer() -> GridDrawer:
	return grid_drawer

func get_grid_map() -> TileMapLayer:
	return grid_map

func get_character_owners() -> Dictionary[String,CharacterOwner]:
	return character_owner_dict

func get_character_dict() -> Dictionary[String,Character]:
	return character_dict

func get_character_array() -> Array[Character]:
	return character_dict.values()

func get_character(id:String) -> Character:
#	print("[Level] CharacterID:",id)
	return character_dict.get(id)
