class_name StatModEffect
extends StatusEffect


## Temporary stat modifier


@export var modifier: StatModifier


func get_description() -> String:
	var result := ""
	if modifier.mod_value > 0:
		result = "+"

	var percent := roundi(modifier.mod_value * 100)
	result += "%d%% " % percent

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


func _set_icon(_value: Texture2D) -> void:
	pass


func _get_icon() -> Texture2D:
	var result: Texture2D = null

	var icon_dict: Dictionary = Constants.STAT_MODS[modifier.mod_type]
	if modifier.mod_value > 0:
		result = icon_dict.up
	else:
		result = icon_dict.down

	return result
