class_name StatModEffect
extends StatusEffect


@export var modifier: StatModifier


func _added_to_actor() -> void:
	actor.stats.add_modifier(modifier)


func _removing_from_actor() -> void:
	actor.stats.remove_modifier(modifier)
