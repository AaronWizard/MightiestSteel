class_name StatModEffect
extends StatusEffect


@export var modifier: StatModifier


func added_to_actor(actor: Actor) -> void:
	actor.stats.add_modifier(modifier)


func removing_from_actor(actor: Actor) -> void:
	actor.stats.remove_modifier(modifier)
