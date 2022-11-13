class_name Map
extends Node2D

@onready var _ground: TileMap = $Ground
@onready var _actors: TileMap = $Actors


## True if cell blocks actors from walking over it.
func cell_blocks_walk(cell: Vector2i) -> bool:
	return _get_tile_property(cell, "blocks_walk")


## True if actors must spend extra movement to walk over cell.
func cell_slows_walk(cell: Vector2i) -> bool:
	return _get_tile_property(cell, "slows_walk")


## True if actor gets defence bonus by standing on cell.
## Large actors need to be covering over half their area of cover cells to get
## defence bonus.
func cell_is_cover(cell: Vector2i) -> bool:
	return _get_tile_property(cell, "is_cover")


## True if cell blocks attack/skill targeting and area-of-effect
func cell_blocks_attack(cell: Vector2i) -> bool:
	return _get_tile_property(cell, "blocks_attack")


## True if cell blocks actors from flying over or being thrown over it.
func cell_blocks_flight(cell: Vector2i) -> bool:
	return _get_tile_property(cell, "blocks_flight")


## True if actors must spend extra movement to fly or be thrown over cell.
func cell_slows_flight(cell: Vector2i) -> bool:
	return _get_tile_property(cell, "slows_flight")


func _get_tile_property(cell: Vector2i, data_layer_name: String):
	_ground.get_cell_tile_data(0, cell).get_custom_data(data_layer_name)
