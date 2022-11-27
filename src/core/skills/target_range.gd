class_name TargetRange
extends Resource

## Gets the cells that can be targeted by an actor's a skill.

@export var target_type := Targets.Type.ANY


func get_range(source_actor: Actor) -> Targets.TargetRangePair:
	var full_range := _get_full_range(source_actor)
	var valid_range := _get_valid_range(full_range, source_actor)
	return Targets.TargetRangePair.new(full_range, valid_range)


## Can be overriden
func _get_full_range(source_actor: Actor) -> Array[Vector2i]:
	return source_actor.covered_cells


func _get_valid_range(full_range: Array[Vector2i], source_actor: Actor) \
		-> Array[Vector2i]:
	return Targets.get_valid_range(full_range, target_type, source_actor)
