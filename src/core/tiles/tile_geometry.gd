class_name TileGeometry


static func get_rect_cells(rect: Rect2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			var covered_cell := Vector2i(x, y)
			result.append(covered_cell)
	return result


static func manhattan_distance(start: Vector2i, end: Vector2i) -> int:
	var diff := (end - start).abs()
	return int(diff.x + diff.y)


static func cells_in_range_square(source_cell: Vector2i, source_size: int,
		min_dist: int, max_dist: int, include_diagonals := true) \
		-> Array[Vector2i]:
	assert(max_dist >= min_dist)
	assert(max_dist >= 1)
	assert(min_dist >= 0)
	assert(source_size >= 1)

	var result: Array[Vector2i] = []

	# Source corners

	var corner_nw := source_cell
	var corner_ne := source_cell + Vector2i(source_size - 1, 0)
	var corner_se := source_cell + Vector2i(source_size - 1, source_size - 1)
	var corner_sw := source_cell + Vector2i(0, source_size - 1)

	assert((source_size > 1) or (
			(corner_nw == corner_ne)
			and (corner_nw == corner_se)
			and (corner_nw == corner_sw)
		))

	# Side quadrants

	var quadrant_n_pos := corner_nw + Vector2i(0, -max_dist)
	var quadrant_e_pos := corner_ne + Vector2i(max(1, min_dist), 0)
	var quadrant_s_pos := corner_sw + Vector2i(0, max(1, min_dist))
	var quadrant_w_pos := corner_nw + Vector2i(-max_dist, 0)

	var quadrant_n_size = Vector2i(source_size, max_dist - max(min_dist, 1) + 1)
	var quadrant_e_size = Vector2i(max_dist - max(min_dist, 1) + 1, source_size)
	var quadrant_s_size = Vector2i(source_size, max_dist - max(min_dist, 1) + 1)
	var quadrant_w_size = Vector2i(max_dist - max(min_dist, 1) + 1, source_size)

	var quadrant_rect_n := Rect2i(quadrant_n_pos, quadrant_n_size)
	var quadrant_rect_e := Rect2i(quadrant_e_pos, quadrant_e_size)
	var quadrant_rect_s := Rect2i(quadrant_s_pos, quadrant_s_size)
	var quadrant_rect_w := Rect2i(quadrant_w_pos, quadrant_w_size)

	if min_dist == 0:
		var self_rect := Rect2i(
			source_cell, Vector2i(source_size, source_size))
		result.append_array(get_rect_cells(self_rect))

	result.append_array(get_rect_cells(quadrant_rect_n))
	result.append_array(get_rect_cells(quadrant_rect_e))
	result.append_array(get_rect_cells(quadrant_rect_s))
	result.append_array(get_rect_cells(quadrant_rect_w))

	if include_diagonals and (max_dist > 1):
		var quadrant_nw_pos := corner_nw + Vector2i(-max_dist, -max_dist)
		var quadrant_ne_pos := corner_ne + Vector2i(1, -max_dist)
		var quadrant_se_pos := corner_se + Vector2i(1, 1)
		var quadrant_sw_pos := corner_sw + Vector2i(-max_dist, 1)

		var quadrant_rect_nw := Rect2i(
				quadrant_nw_pos, Vector2i(max_dist, max_dist))
		var quadrant_rect_ne := Rect2i(
				quadrant_ne_pos, Vector2i(max_dist, max_dist))
		var quadrant_rect_se := Rect2i(
				quadrant_se_pos, Vector2i(max_dist, max_dist))
		var quadrant_rect_sw := Rect2i(
				quadrant_sw_pos, Vector2i(max_dist, max_dist))

		var flood_start_nw := corner_nw + Vector2i(-1, -1)
		var flood_start_ne := corner_ne + Vector2i(1, -1)
		var flood_start_se := corner_se + Vector2i(1, 1)
		var flood_start_sw := corner_sw + Vector2i(-1, 1)

		result.append_array(_flood_fill(corner_nw, flood_start_nw, min_dist,
				max_dist, quadrant_rect_nw))
		result.append_array(_flood_fill(corner_ne, flood_start_ne, min_dist,
				max_dist, quadrant_rect_ne))
		result.append_array(_flood_fill(corner_se, flood_start_se, min_dist,
				max_dist, quadrant_rect_se))
		result.append_array(_flood_fill(corner_sw, flood_start_sw, min_dist,
				max_dist, quadrant_rect_sw))

	return result


static func _flood_fill(origin: Vector2i, start: Vector2i,
		min_dist: int, max_dist: int, bounds: Rect2i) -> Array[Vector2i]:
	var result := {}

	var stack: Array[Vector2i] = [start]
	var visited := {}

	while not stack.is_empty():
		var current := stack.pop_back() as Vector2

		if not visited.has(current) and bounds.has_point(current) \
				and (manhattan_distance(origin, current) <= max_dist):
			visited[current] = true
			if manhattan_distance(origin, current) >= min_dist:
				result[current] = true

			for d in Directions.get_all_vectors():
				var dir := d as Vector2
				var adj := current + dir

				if not visited.has(adj):
					stack.push_back(adj)

	return result.keys()
