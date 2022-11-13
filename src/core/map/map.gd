class_name Map
extends Node2D

## A map with terrain and actors.


## Actors on the map
var actors: Array[Actor]:
	get:
		var result: Array[Actor] = []
		for a in _actors.get_children():
			result.append(a)
		return result


@onready var _ground: TileMap = $Ground
@onready var _actors: Node = $Actors


func _ready() -> void:
	_init_actors.call_deferred()


## Terrain data at the given cell
func get_terrain_data(cell: Vector2i) -> TerrainData:
	return TerrainData.new(_ground.get_cell_tile_data(0, cell))


## Adds an actor
func add_actor(actor: Actor) -> void:
	assert(not actor in _actors.get_children())
	if actor.map:
		var other_map := actor.map as Map
		other_map.remove_actor(actor)

	_actors.add_child(actor)
	actor.map = self


## Removes an actor
func remove_actor(actor: Actor) -> void:
	assert(actor in _actors.get_children())
	_actors.remove_child(actor)
	actor.map = null


func _init_actors() -> void:
	for a in actors:
		a.map = self
