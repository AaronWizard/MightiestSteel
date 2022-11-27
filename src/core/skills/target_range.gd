class_name TargetRange
extends Resource

## Gets the cells that can be targeted by an actor's a skill.


class TargetRangePair:
	## The full and valid range of a skill.
	##
	## Paired because the valid range is a subset of the full range.

	var full: Array[Vector2i]
	var valid: Array[Vector2i]

	func _init(new_full: Array[Vector2i], new_valid: Array[Vector2i]) -> void:
		full = new_full
		valid = new_valid


@export var target_type := TargetType.Type.ANY


func get_range(source_actor: Actor) -> TargetRangePair:
	var full_range := _get_full_range(source_actor)
	var valid_range := _get_valid_range(full_range, source_actor)
	return TargetRangePair.new(full_range, valid_range)


## Can be overriden
func _get_full_range(source_actor: Actor) -> Array[Vector2i]:
	return source_actor.covered_cells


func _get_valid_range(full_range: Array[Vector2i], source_actor: Actor) \
		-> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell in full_range:
		if TargetType.is_valid_target(cell, target_type, source_actor):
			result.append(cell)
	return result
