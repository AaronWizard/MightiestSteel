class_name Directions

enum Direction
{
	NORTH,
	SOUTH,
	EAST,
	WEST
}

const _VALUES := {
	Direction.NORTH: Vector2i.UP,
	Direction.EAST: Vector2i.RIGHT,
	Direction.SOUTH: Vector2i.DOWN,
	Direction.WEST: Vector2i.LEFT
}


static func get_all_vectors() -> Array[Vector2i]:
	return _VALUES.values()


static func get_vector(direction: Direction) -> Vector2i:
	return _VALUES[direction]
