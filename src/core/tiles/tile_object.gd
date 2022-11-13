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
		return Vector2i(position / float(Constants.TILE_SIZE)) - Vector2i.DOWN
	set(value):
		position = (value + Vector2i.DOWN) * Constants.TILE_SIZE


## The cell size.
## Turns into a pixel size that is a multiple of Constants.TILE_SIZE. Is always
## square.
@export_range(1, 1, 1, "or_greater") var cell_size := 1:
	set(value):
		cell_size = value
		if _center:
			_center.position = Vector2(1, -1) * Constants.TILE_HALF_SIZE_V \
					* cell_size
		queue_redraw()


## The rectangle in cells that the tile object covers.
var cell_rect: Rect2i:
	get:
		var rect_pos := origin_cell + (Vector2i.UP * (cell_size - 1))
		var rect_size := Vector2i(cell_size, cell_size)
		return Rect2i(rect_pos, rect_size)


## The cells covered by the tile object.
var covered_cells: Array[Vector2i]:
	get:
		var result: Array[Vector2i] = []
		for x in range(cell_size):
			for y in range(cell_size):
				var cell := Vector2i(x, y)
				result.append(cell)
		return result


## The cell that is at the center of the tile object. May be between grid cells.
var center_cell: Vector2:
	get:
		var result := Vector2.ZERO
		if _center:
			var pixel_pos := position + _center.position
			var cell_pos := pixel_pos / float(Constants.TILE_SIZE)
			result = cell_pos - Vector2(0.5, 0.5)
		return result


@onready var _center: Node2D = $Center


func _ready():
	origin_cell = origin_cell # Force snap to grid


func _draw():
	var rect_pos := Vector2(0, -cell_size * Constants.TILE_SIZE)
	var rect_size := Vector2(cell_size, cell_size) * Constants.TILE_SIZE
	var rect := Rect2(rect_pos, rect_size)
	draw_rect(rect, Color.MAGENTA, false, 1)


## Checks if a cell is covered by the tile object.
func is_on_cell(cell: Vector2i) -> bool:
	return cell_rect.has_point(cell)
