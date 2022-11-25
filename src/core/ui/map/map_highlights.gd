class_name MapHighlights
extends Node

const _TILE_ATLAS_MOVE := Vector2i(0, 0)
const _TILE_ATLAS_OTHER_MOVE := Vector2i(0, 1)
const _TILE_ATLAS_TARGET := Vector2i(0, 2)
const _TILE_ATLAS_VALID_TARGET := Vector2i(0, 3)
const _TILE_ATLAS_AOE := Vector2i(0, 4)

const _LAYER_MOVE := 0
const _LAYER_OTHER := 1
const _LAYER_TARGET := 2


var target_cursor: TileObject:
	get:
		return $TargetCursor


@onready var _highlights: TileMap = $Highlights


func set_move_range(cells: Array[Vector2i]) -> void:
	_set_tiles(cells, _LAYER_MOVE, _TILE_ATLAS_MOVE)


func set_other_move_range(cells: Array[Vector2i]) -> void:
	_set_tiles(cells, _LAYER_OTHER, _TILE_ATLAS_OTHER_MOVE)


func set_target_range(cells: Array[Vector2i], valid_cells: Array[Vector2i]) \
		-> void:
	_set_tiles(cells, _LAYER_TARGET, _TILE_ATLAS_TARGET)
	_set_tiles(valid_cells, _LAYER_TARGET, _TILE_ATLAS_VALID_TARGET, false)


func clear_other_range() -> void:
	_highlights.clear_layer(_LAYER_OTHER)


func clear_all() -> void:
	_highlights.clear()


func _set_tiles(cells: Array[Vector2i], layer: int, tile_atlas: Vector2i,
		clear_layer: bool = true) -> void:
	if clear_layer:
		_highlights.clear_layer(layer)
	for c in cells:
		_highlights.set_cell(layer, c, 0, tile_atlas)
