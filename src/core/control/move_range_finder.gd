class_name MoveRangeFinder

# Dijkstra's Algorithm
static func find_move_range(actor: Actor, map: Map) -> Array[Vector2i]:
	var result: Array[Vector2i] = []

	var move_costs := { actor.origin_cell: 0 }
	var queue: Array[Vector2i] = [ actor.origin_cell ]

	while not queue.is_empty():
		var current_cell_index := _next_cell_index(queue, move_costs)
		var current_cell := queue[current_cell_index]
		queue.remove_at(current_cell_index)

		result.append(current_cell)

		var current_cost: int = move_costs[current_cell]
		if (current_cost == 0) \
				or not map.actor_stopped_by_cell(current_cell, actor):
			var adjacent := _adjacent_cells(current_cell, actor, map)
			for adj_cell in adjacent:
				var adj_cost := map.get_cell_move_cost(adj_cell, actor) \
						+ current_cost

				if (adj_cost <= actor.stats.move) \
						and ( not move_costs.has(adj_cell) \
						or (adj_cost < move_costs[adj_cell]) ):
					move_costs[adj_cell] = adj_cost
					if queue.find(adj_cell) == -1:
						queue.append(adj_cell)

	return result


static func _next_cell_index(queue: Array[Vector2i], move_costs: Dictionary) \
		-> int:
	var result := 0
	var result_cell := queue[result]
	var result_cost: int = move_costs[result_cell]

	for i in range(1, queue.size()):
		var other_cell := queue[i]
		var other_cost: int = move_costs[other_cell]

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
