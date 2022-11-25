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


## The types of cells that are valid targets.
enum TargetType {
	## Any cells within the skill's full range
	ANY,

	## Any cells within the skill's full range that contains an actor
	ANY_ACTOR,

	## Any cells within the skill's full range that contains an actor who is an
	## enemy of the skill's source actor
	ENEMY,

	## Any cells within the skill's full range that contains an actor who is an
	## ally of the skill's source actor
	ALLY,

	## Any cells within the skill's full range that has no actor covering it
	EMPTY_CELL,

	## Any cells within the skill's full range that the skill's source actor may
	## occupy
	ENTERABLE_CELL
}

@export var target_type := TargetType.ANY


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
		if _is_valid_target(cell, source_actor):
			result.append(cell)
	return result


func _is_valid_target(cell: Vector2i, source_actor: Actor) -> bool:
	var result := false

	if target_type == TargetType.ENTERABLE_CELL:
		result = source_actor.map.actor_can_enter_cell(source_actor, cell)
	else:
		var actor_on_target := source_actor.map.get_actor_on_cell(cell)

		match target_type:
			TargetType.EMPTY_CELL:
				result = actor_on_target == null
			TargetType.ENEMY, TargetType.ALLY, TargetType.ANY_ACTOR:
				if actor_on_target:
					match target_type:
						TargetType.ENEMY:
							result = actor_on_target.faction \
									!= source_actor.faction
						TargetType.ALLY:
							result = actor_on_target.faction \
									== source_actor.faction
						_:
							result = true
				else:
					result = false
			_:
				assert(target_type == TargetType.ANY)
				result = true

	return result
