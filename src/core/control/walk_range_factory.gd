class_name WalkRangeFactory


static func create_walk_range(actor: Actor, map: Map) -> WalkRange:
	var base_move_range := _create_base_move_range(actor, map)

	var true_move_range := _create_true_move_range(base_move_range, actor, map)
	var visible_move_range := _create_visible_move_range(true_move_range,
			base_move_range, actor)

	var walk_grid := _create_walk_grid(base_move_range)

	return WalkRange.new(
		actor.origin_cell,
		true_move_range,
		visible_move_range,
		walk_grid
	)


# Includes cells with allies on them. Actor can pass through allies but not end
# their movement on an occupied cell.
static func _create_base_move_range(actor: Actor, map: Map) -> Dictionary:
	var result := {}
	var mr := MoveRangeFinder.find_move_range(actor, map)
	for c in mr:
		result[c] = true
	return result


# Cells the actor can actually occupy
static func _create_true_move_range(base_move_range: Dictionary,
		actor: Actor, map: Map) -> Dictionary:
	var result := {}
	for c in base_move_range:
		if map.actor_can_enter_cell(actor, c):
			result[c] = true
	return result


# Cells covered by the actor within its move range.
# e.g. Cells outside of the actor's true move range but covered by the actor if
# it is larger than one cell.
static func _create_visible_move_range(true_move_range: Dictionary,
		base_move_range: Dictionary, actor: Actor) -> Dictionary:
	var result := {}

	for origin_cell in base_move_range:
		for covered_cell in actor.get_covered_cells_at_cell(origin_cell):
			result[covered_cell] = origin_cell
	# Make sure origin cells map to themselves
	for origin_cell in true_move_range:
		result[origin_cell] = origin_cell

	return result


static func _create_walk_grid(move_range: Dictionary) -> AStar2D:
	var result := AStar2D.new()

	for cell in move_range:
		result.add_point(result.get_available_point_id(), cell)
	_init_walk_grid_paths(result)

	return result


static func _init_walk_grid_paths(walk_grid: AStar2D) -> void:
	for point in walk_grid.get_point_ids():
		var cell := Vector2i(walk_grid.get_point_position(point))
		for dir in Directions.get_all_vectors():
			var adj_cell := dir + cell

			var adj_point := WalkRange.walk_path_point(walk_grid, adj_cell)
			if (adj_point > -1) \
					and not walk_grid.are_points_connected(point, adj_point):
				walk_grid.connect_points(point, adj_point)
