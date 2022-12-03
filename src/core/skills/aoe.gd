class_name AOE
extends Resource

## Gets the cells that in the AOE of a skill's target

@export var target_type := TargetRangeData.TargetType.ANY


func get_aoe(target_cell: Vector2i, source_actor: Actor) -> TargetRangeData:
	var full_range := _get_full_range(target_cell, source_actor)
	return TargetRangeData.new(full_range, target_type, source_actor)


## Can be overriden
func _get_full_range(target_cell: Vector2i, _source_actor: Actor) \
		-> Array[Vector2i]:
	return [target_cell]
