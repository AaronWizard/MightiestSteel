class_name TargetType


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


static func is_valid_target(cell: Vector2i, target_type: Type,
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
