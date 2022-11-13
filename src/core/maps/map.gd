class_name Map
extends Node2D

@onready var _ground: TileMap = $Ground
@onready var _actors: TileMap = $Actors


func get_terrain_data(cell: Vector2i) -> TerrainData:
	return TerrainData.new(_ground.get_cell_tile_data(0, cell))
