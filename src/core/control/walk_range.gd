class_name WalkRange

## The cell the actor was on before moving.
var origin_cell: Vector2i:
	get:
		return _origin_cell


## Cells the actor can occupy within its move range.
var move_range: Array[Vector2i]:
	get:
		var result: Array[Vector2i] = []
		result.assign(_true_move_range.keys())
		return result


## Cells covered by the actor within its move range.
## e.g. Cells outside of the actor's true move range but covered by the actor if
## it is larger than one cell.
var visible_move_range: Array[Vector2i]:
	get:
		var result: Array[Vector2i] = []
		result.assign(_visible_move_range.keys())
		return result


var _origin_cell: Vector2i
# Keys are Vector2i's
var _true_move_range: Dictionary
# Keys are Vector2i's. Values are Vector2i's in _true_move_range.
var _visible_move_range: Dictionary

var _walk_grid: AStar2D


func _init(new_origin_cell: Vector2i, new_true_move_range: Dictionary,
		new_visible_move_range: Dictionary, new_walk_grid: AStar2D) -> void:
	origin_cell = new_origin_cell
	_true_move_range = new_true_move_range
	_visible_move_range = new_visible_move_range
	_walk_grid = new_walk_grid


static func walk_path_point(walk_grid: AStar2D, cell: Vector2) -> int:
	var result := walk_grid.get_closest_point(cell)
	if (result == -1) or (walk_grid.get_point_position(result) != cell):
		result = -1
	return result


func in_move_range(cell: Vector2i) -> bool:
	return _true_move_range.has(cell)


## Get path between points within the move range.
## If use_visible_move_range is true, start and end may be in the visible move
## range instead of the true move range.
func get_move_path(start: Vector2i, end: Vector2i,
		use_visible_move_range := false) -> Array[Vector2i]:
	var result: Array[Vector2i] = []

	var true_end := end
	if use_visible_move_range and _visible_move_range.has(end):
		true_end = _visible_move_range[end]

	if (start != true_end) and _true_move_range.has(start) \
			and _true_move_range.has(true_end):
		var end_point := _walk_path_point(true_end)
		if end_point > -1:
			var start_point := _walk_path_point(start)
			assert(start_point > -1)

			var new_path := _walk_grid.get_point_path(
					start_point, end_point)
			result.assign(new_path)
			result.pop_front() # Remove starting cell
			assert(result.size() > 0)

	return result


func _walk_path_point(cell: Vector2) -> int:
	return WalkRange.walk_path_point(_walk_grid, cell)
