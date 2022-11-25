class_name CellDistanceRange
extends TargetRange

@export_range(0, 1, 1, "or_greater") var min_dist := 1
@export_range(0, 1, 1, "or_greater") var max_dist := 1
@export var include_diagonals := true


func _get_full_range(source_actor: Actor) -> Array[Vector2i]:
	return TileGeometry.cells_in_range_square(
			source_actor.origin_cell, source_actor.cell_size,
			min_dist, max_dist, include_diagonals)
