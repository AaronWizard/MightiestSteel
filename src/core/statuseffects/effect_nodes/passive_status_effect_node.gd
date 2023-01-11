class_name PassiveStatusEffectNode
extends BaseStatusEffectNode

## An actor's passive status effects.


var effects: Array[PassiveStatusEffect] = []:
	set(value):
		effects = value
		for e in effects:
			e.added_to_actor(actor)


func _get_effects() -> Array[BaseStatusEffect]:
	return effects
