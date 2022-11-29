class_name TargetRangeData

## The full and valid range of a skill or AOE, along with affected actors.
##
## Combined because the valid range and affected actors are derived from the
## full range.

## The types of cells that are valid targets.
enum Type {
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


## The full set of cells in range
var full: Array[Vector2i]:
	get:
		return _full


## The cells in range that will be affected by the target range or AOE
var valid: Array[Vector2i]:
	get:
		return _valid


## The actors with in the valid range
var actors: Array[Actor]:
	get:
		return _actors


var _full: Array[Vector2i]
var _valid: Array[Vector2i]
var _actors: Array[Actor]


func _init(full_range: Array[Vector2i], target_type: Type,
		source_actor: Actor) -> void:
	_full = full_range
	_init_valid_range(target_type, source_actor)
	_actors = source_actor.map.get_actors_in_area(_valid)


func _init_valid_range(target_type: Type,
		source_actor: Actor) -> void:
	_valid = []
	for cell in _full:
		if TargetRangeData._is_valid_target(cell, target_type, source_actor):
			_valid.append(cell)


static func _is_valid_target(cell: Vector2i, target_type: Type,
		source_actor: Actor) -> bool:
	var result := false

	if target_type == Type.ENTERABLE_CELL:
		result = source_actor.map.actor_can_enter_cell(source_actor, cell)
	else:
		var actor_on_target := source_actor.map.get_actor_on_cell(cell)

		match target_type:
			Type.EMPTY_CELL:
				result = actor_on_target == null
			Type.ENEMY, Type.ALLY, Type.ANY_ACTOR:
				if actor_on_target:
					match target_type:
						Type.ENEMY:
							result = actor_on_target.faction \
									!= source_actor.faction
						Type.ALLY:
							result = actor_on_target.faction \
									== source_actor.faction
						_:
							result = true
				else:
					result = false
			_:
				assert(target_type == Type.ANY)
				result = true

	return result
