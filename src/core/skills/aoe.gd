class_name AOE
extends Resource

## Gets the cells that in the AOE of a skill's target

@export var target_type := Targets.Type.ANY


func get_aoe(target_cell: Vector2i, source_actor: Actor) \
		-> Targets.TargetRangePair:
	var full_range := _get_full_range(target_cell, source_actor)
	var valid_range := Targets.get_valid_range(
			full_range, target_type, source_actor)
	return Targets.TargetRangePair.new(full_range, valid_range)


## Can be overriden
func _get_full_range(target_cell: Vector2i, _source_actor: Actor) \
		-> Array[Vector2i]:
	return [target_cell]
