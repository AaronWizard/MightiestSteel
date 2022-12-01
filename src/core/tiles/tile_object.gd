@tool
class_name TileObject
extends Node2D

## A node with a tile cell position and size.
##
## Has an origin cell that positions itself based on Constants.TILE_SIZE.
## Also has a square size in cells. Can report its center cell and what cells it
## covers.


## The origin cell that controls positioning.
## Turns into a pixel position that is a multiple of Constants.TILE_SIZE and
## makes the tile object occupy an equivalent grid cell.
## The pixel position is always at the bottom-left, though the origin cell
## always conforms to standard grid positioning where positive y-values go down
## the screen.
@export var origin_cell := Vector2i.ZERO:
	get:
		return _get_origin_cell()
	set(value):
		_set_origin_cell(value)


## The cell size.
## Turns into a pixel size that is a multiple of Constants.TILE_SIZE. Is always
## square.
@export_range(1, 1, 1, "or_greater") var cell_size := 1:
	set(value):
		cell_size = value
		_update_size()


## The rectangle in cells that the tile object covers.
var cell_rect: Rect2i:
	get:
		return get_cell_rect_at_cell(origin_cell)


## Local rectangle in pixels
var pixel_rect: Rect2i:
	get:
		var rect_pos := Vector2i(0, -cell_size * Constants.TILE_SIZE)
		var rect_size := Vector2i(cell_size, cell_size) * Constants.TILE_SIZE
		return Rect2i(rect_pos, rect_size)


## The cells covered by the tile object.
var covered_cells: Array[Vector2i]:
	get:
		return get_covered_cells_at_cell(origin_cell)


## The cell that is at the center of the tile object. May be between grid cells.
var center_cell: Vector2:
	get:
		var result := Vector2.ZERO
		if _center:
			var pixel_pos := position + _center.position
			var cell_pos := pixel_pos / float(Constants.TILE_SIZE)
			result = cell_pos - Vector2(0.5, 0.5)
		return result


## Pixel position of center
var center_position: Vector2:
	get:
		var result := position
		if _center:
			result += _center.position
		return result


@onready var _center: Node2D = $Center


func _ready():
	origin_cell = origin_cell # Force snap to grid
	cell_size = cell_size # Force cell size


func _draw():
	if Engine.is_editor_hint():
		draw_rect(pixel_rect, Color.MAGENTA, false, 1)


## Rect2i that object would cover at given origin cell
func get_cell_rect_at_cell(cell: Vector2i) -> Rect2i:
	var rect_pos := cell + (Vector2i.UP * (cell_size - 1))
	var rect_size := Vector2i(cell_size, cell_size)
	return Rect2i(rect_pos, rect_size)


## Cells that object would cover at given origin cell
func get_covered_cells_at_cell(cell: Vector2i) -> Array[Vector2i]:
	var rect := get_cell_rect_at_cell(cell)
	return TileGeometry.get_rect_cells(rect)


## Checks if a cell is covered by the tile object.
func is_on_cell(cell: Vector2i) -> bool:
	return cell_rect.has_point(cell)


func _update_size() -> void:
	if _center:
		_center.position = Vector2(1, -1) * Constants.TILE_HALF_SIZE_V \
				* cell_size
	queue_redraw()


func _get_origin_cell() -> Vector2i:
	return Vector2i(position / float(Constants.TILE_SIZE)) - Vector2i.DOWN


func _set_origin_cell(cell: Vector2i) -> void:
	position = (cell + Vector2i.DOWN) * Constants.TILE_SIZE
