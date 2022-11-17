class_name MoveRangeFinder

# Dijkstra's Algorithm
static func find_move_range(actor: Actor, map: Map) -> Array[Vector2i]:
	var result := {}

	var costs := { actor.origin_cell: 0 }
	var queue: Array[Vector2i] = [ actor.origin_cell ]

	while not queue.is_empty():
		var current_cell_index := _next_cell_index(queue, costs)
		var current_cell := queue[current_cell_index]
		queue.remove_at(current_cell_index)

		result[current_cell] = true

		var adjacent := _adjacent_cells(current_cell, actor, map)
		for adj_cell in adjacent:
			var adj_cost := map.get_cell_move_cost(adj_cell, actor)
			adj_cost += costs[current_cell] as int

			if adj_cost <= actor.stats.move and ( \
					not costs.has(adj_cell) or (adj_cost < costs[adj_cell]) ):
				costs[adj_cell] = adj_cost
				if queue.find(adj_cell) == -1:
					queue.append(adj_cell)

	return result.keys()


static func _next_cell_index(queue: Array[Vector2i], costs: Dictionary) -> int:
	var result := 0
	var result_cell := queue[result]
	var result_cost: int = costs[result_cell]

	for i in range(1, queue.size()):
		var other_cell := queue[i]
		var other_cost := costs[other_cell] as int

		if other_cost < result_cost:
			result = i
			result_cost = other_cost

	return result


# Ignores allied actors
static func _adjacent_cells(cell: Vector2i, actor: Actor, map: Map) \
		-> Array[Vector2i]:
	var result: Array[Vector2i] = []

	for d in Directions.get_all_vectors():
		var next_cell := cell + d
		if map.actor_can_enter_cell(actor, next_cell, true):
			result.append(next_cell)

	return result
