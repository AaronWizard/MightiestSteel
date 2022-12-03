class_name Map
extends Node

## A map with terrain and actors.

const _MOVE_COST_CLEAR := 1
const _MOVE_COST_ROUGH := 2


## The cell that the mouse is over
var mouse_cell: Vector2i:
	get:
		return _ground.local_to_map(_ground.get_global_mouse_position())


## The size of the map in pixels
var pixel_rect: Rect2i:
	get:
		var rect := _ground.get_used_rect()
		var rectpos := Vector2(rect.position * _ground.tile_set.tile_size)
		var rectsize := Vector2(rect.size * _ground.tile_set.tile_size)
		return Rect2i(rectpos, rectsize)


## Actors on the map
var actors: Array[Actor]:
	get:
		var result: Array[Actor] = []
		for a in _actors.get_children():
			result.append(a)
		return result


@onready var _ground: TileMap = $Ground
@onready var _actors: Node = $Actors
@onready var _effects: Node = $Effects


func _ready() -> void:
	for a in actors:
		_setup_added_actor(a)


## Map updates to run when a new round starts
func start_round(is_first_round: bool) -> void:
	for a in actors:
		a.start_round(is_first_round)


## Terrain data at the given cell, or null if no data present
func get_terrain_data(cell: Vector2i) -> TerrainData:
	var result: TerrainData = null

	for i in range(_ground.get_layers_count() - 1, -1, -1):
		var base_data := _ground.get_cell_tile_data(0, cell)
		if base_data:
			result = TerrainData.new(base_data)
			break

	return result


## Gets how many movement points an actor must spend to enter this cell
func get_cell_move_cost(cell: Vector2i, actor: Actor) -> int:
	var result := _MOVE_COST_CLEAR

	for covered_cell in actor.get_covered_cells_at_cell(cell):
		var terrain_data := get_terrain_data(covered_cell)
		if terrain_data and terrain_data.slows_walk:
			result = _MOVE_COST_ROUGH
			break

	return result


## Adds an effect
func add_effect(effect: Node2D) -> void:
	_effects.add_child(effect)


## Adds an actor
func add_actor(actor: Actor) -> void:
	assert(not actor in _actors.get_children())
	if actor.map:
		var other_map := actor.map
		other_map.remove_actor(actor)

	_actors.add_child(actor)
	_setup_added_actor(actor)


## Removes an actor
func remove_actor(actor: Actor) -> void:
	assert(actor in _actors.get_children())
	_actors.remove_child(actor)
	_setup_removed_actor(actor)


## Gets all actors belonging to the given faction
func get_actors_by_faction(faction: int) -> Array[Actor]:
	var result: Array[Actor] = []
	for a in actors:
		if a.faction == faction:
			result.append(a)
	return result


## Gets actor that covers cell, or null if cell is empty
func get_actor_on_cell(cell: Vector2i) -> Actor:
	var result: Actor = null
	for a in actors:
		if a.is_on_cell(cell):
			result = a
			break
	return result


## Gets all actors that are covered by any cell in the given set of cells
func get_actors_in_area(area: Array[Vector2i]) -> Array[Actor]:
	var result := {}
	for cell in area:
		var actor := get_actor_on_cell(cell)
		result[actor] = true
	return result.keys()


## Checks if actor can occupy cell (as it's origin cell).
## Set ignore_allied_actors to allow actor to pass through allies.
func actor_can_enter_cell(actor: Actor, cell: Vector2i,
		ignore_allied_actors: bool = false) -> bool:
	var result := true

	var covered_cells := actor.get_covered_cells_at_cell(cell)
	for covered_cell in covered_cells:
		if not _ground.get_used_rect().has_point(covered_cell):
			result = false
			break

		var terrain_data := get_terrain_data(covered_cell)
		if terrain_data and terrain_data.blocks_walk:
			result = false
			break

		var other_actor := get_actor_on_cell(covered_cell)
		var is_blocking_actor := (other_actor != null) \
				and (other_actor != actor) \
				and (not ignore_allied_actors \
					or (other_actor.faction != actor.faction) \
				)
		if is_blocking_actor:
			result = false
			break

	return result


## Checks if actor has defence bonus at cell.
## An actor has a defence bonus if over half of the cells it covers are cover
## tiles.
func actor_has_cover_at_cell(actor: Actor, cell: Vector2i) -> bool:
	var defensive_tiles := 0
	var clear_tiles := 0

	for covered_cell in actor.get_covered_cells_at_cell(cell):
		var terrain_data := get_terrain_data(covered_cell)
		if terrain_data and terrain_data.is_cover:
			defensive_tiles += 1
		else:
			clear_tiles += 1

	return defensive_tiles > clear_tiles


func _setup_added_actor(actor: Actor) -> void:
	actor.map = self
	actor.moved.connect(_actor_moved.bind(actor))


func _setup_removed_actor(actor: Actor) -> void:
	actor.map = null
	actor.moved.disconnect(_actor_moved)


func _actor_moved(_actor: Actor) -> void:
	pass


func _actor_died(actor: Actor) -> void:
	if actor.is_animating:
		await actor.animation_finished
	remove_actor(actor)
