class_name TileGeometry


static func get_line_cells(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = [start]

	if end != start:
		var diff := (end - start).abs()
		var diagonal_dist := maxi(diff.x, diff.y)

		var startf := Vector2(start)
		for i in range(1, diagonal_dist):
			var weight := float(i) / float(diagonal_dist)
			var line_point := startf.lerp(end, weight)
			result.append( Vector2i( line_point.round() ) )

		result.append(end)

	return result


static func get_rect_cells(rect: Rect2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			var covered_cell := Vector2i(x, y)
			result.append(covered_cell)
	return result


static func manhattan_distance(start: Vector2i, end: Vector2i) -> int:
	var diff := (end - start).abs()
	return diff.x + diff.y


static func cells_in_range(cell: Vector2i, min_dist: int, max_dist: int,
		include_diagonals := true) -> Array[Vector2i]:
	var rect := Rect2i(cell, Vector2i.ONE)
	return cells_in_range_rect(rect, min_dist, max_dist, include_diagonals)


static func cells_in_range_rect(rect: Rect2i, min_dist: int, max_dist: int,
		include_diagonals := true) -> Array[Vector2i]:
	assert(max_dist >= min_dist)
	assert(max_dist >= 1)
	assert(min_dist >= 0)

	var result: Array[Vector2i] = []

	# Source corners

	var corner_nw := rect.position
	var corner_ne := rect.position + Vector2i(rect.size.x - 1, 0)
	var corner_se := rect.end - Vector2i.ONE
	var corner_sw := rect.position + Vector2i(0, rect.size.y - 1)

	# Side quadrants

	var quadrant_n_pos := corner_nw + Vector2i(0, -max_dist)
	var quadrant_e_pos := corner_ne + Vector2i(max(1, min_dist), 0)
	var quadrant_s_pos := corner_sw + Vector2i(0, max(1, min_dist))
	var quadrant_w_pos := corner_nw + Vector2i(-max_dist, 0)

	var quadrant_n_size = Vector2i(rect.size.x, max_dist - max(min_dist, 1) + 1)
	var quadrant_e_size = Vector2i(max_dist - max(min_dist, 1) + 1, rect.size.y)
	var quadrant_s_size = Vector2i(rect.size.x, max_dist - max(min_dist, 1) + 1)
	var quadrant_w_size = Vector2i(max_dist - max(min_dist, 1) + 1, rect.size.y)

	var quadrant_rect_n := Rect2i(quadrant_n_pos, quadrant_n_size)
	var quadrant_rect_e := Rect2i(quadrant_e_pos, quadrant_e_size)
	var quadrant_rect_s := Rect2i(quadrant_s_pos, quadrant_s_size)
	var quadrant_rect_w := Rect2i(quadrant_w_pos, quadrant_w_size)

	if min_dist == 0:
		result.append_array(get_rect_cells(rect))

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
	var flood_fill := {}

	var stack: Array[Vector2i] = [start]
	var visited := {}

	while not stack.is_empty():
		var current: Vector2i = stack.pop_back()

		if not visited.has(current) and bounds.has_point(current) \
				and (manhattan_distance(origin, current) <= max_dist):
			visited[current] = true
			if manhattan_distance(origin, current) >= min_dist:
				flood_fill[current] = true

			for dir in Directions.get_all_vectors():
				var adj := current + dir

				if not visited.has(adj):
					stack.push_back(adj)

	var result: Array[Vector2i] = []
	result.assign(flood_fill.keys())
	return result
