class_name BaseStatusEffect
extends Resource

## Base logic for status effects.

## When a new round has started.
## Can be overriden.
func round_started(_actor: Actor) -> void:
	pass
