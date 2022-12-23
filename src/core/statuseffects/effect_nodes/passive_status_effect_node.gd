class_name PassiveStatusEffectNode
extends BaseStatusEffectNode

## A node for a passive status effect.
##
## Not meant to be used in the scene editor.


var effect: PassiveStatusEffect:
	get:
		return _effect


var _effect: PassiveStatusEffect


func _init(new_effect: PassiveStatusEffect, new_actor: Actor) -> void:
	_effect = new_effect
	super(new_actor)


func _get_effect() -> BaseStatusEffect:
	return _effect
