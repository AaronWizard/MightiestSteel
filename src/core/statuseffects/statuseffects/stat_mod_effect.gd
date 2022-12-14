class_name StatModEffect
extends StatusEffect


@export var modifier: StatModifier


func get_description() -> String:
	var result := ""
	if modifier.mod_value > 0:
		result = "+"

	var percent := roundi(modifier.mod_value * 100)
	result += "%d " % percent

	match modifier.mod_type:
		Stats.ModifierTypes.MAX_STAMINA:
			result += "max stamina"
		Stats.ModifierTypes.ATTACK:
			result += "attack"
		Stats.ModifierTypes.MOVE:
			result += "move"
		Stats.ModifierTypes.SPEED:
			result += "speed"
		Stats.ModifierTypes.DEFENCE:
			result += "defence"

	return result


func added_to_actor(actor: Actor) -> void:
	actor.stats.add_modifier(modifier)


func removing_from_actor(actor: Actor) -> void:
	actor.stats.remove_modifier(modifier)
