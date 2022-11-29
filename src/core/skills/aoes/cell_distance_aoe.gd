class_name CellDistanceAOE
extends AOE

@export_range(0, 1, 1, "or_greater") var min_dist := 1
@export_range(0, 1, 1, "or_greater") var max_dist := 1


func _get_full_range(target_cell: Vector2i, _source_actor: Actor) \
		-> Array[Vector2i]:
	return TileGeometry.cells_in_range(target_cell, min_dist, max_dist)
