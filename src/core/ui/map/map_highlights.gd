class_name MapHighlights
extends Node

const _TILE_ATLAS_MOVE := Vector2i(0, 0)
const _TILE_ATLAS_OTHER_MOVE := Vector2i(0, 1)
const _TILE_ATLAS_TARGET := Vector2i(0, 2)
const _TILE_ATLAS_VALID_TARGET := Vector2i(0, 3)
const _TILE_ATLAS_AOE := Vector2i(0, 4)

const _LAYER_MOVE_RANGE := 0
const _LAYER_OTHER_RANGE := 1

@onready var _highlights: TileMap = $Highlights


func set_move_range(cells: Array[Vector2i]) -> void:
	_set_tiles(cells, _LAYER_MOVE_RANGE, _TILE_ATLAS_MOVE)


func set_other_move_range(cells: Array[Vector2i]) -> void:
	_set_tiles(cells, _LAYER_OTHER_RANGE, _TILE_ATLAS_OTHER_MOVE)


func clear_move_range() -> void:
	_highlights.clear_layer(_LAYER_MOVE_RANGE)


func clear_other_range() -> void:
	_highlights.clear_layer(_LAYER_OTHER_RANGE)


func clear_all() -> void:
	_highlights.clear()


func _set_tiles(cells: Array[Vector2i], layer: int, tile_atlas: Vector2i) \
		-> void:
	_highlights.clear_layer(layer)
	for c in cells:
		_highlights.set_cell(layer, c, 0, tile_atlas)
