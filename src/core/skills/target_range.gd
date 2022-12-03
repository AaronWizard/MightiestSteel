class_name TargetRange
extends Resource

## Gets the cells that can be targeted by an actor's a skill.

@export var target_type := TargetRangeData.TargetType.ANY


func get_range(source_actor: Actor) -> TargetRangeData:
	var full_range := _get_full_range(source_actor)
	return TargetRangeData.new(full_range, target_type, source_actor)


## Can be overriden
func _get_full_range(source_actor: Actor) -> Array[Vector2i]:
	return source_actor.covered_cells
