class_name BaseStatusEffect
extends Resource

## Base logic for status effects.


## When the status effect is first added to the actor.
## Can be overriden.
func added_to_actor(_affected_actor: Actor) -> void:
	pass


## When a round starts.
## Can be overriden.
func round_started(_affected_actor: Actor) -> void:
	pass


## When any actor starts its turn.
## Can be overriden.
func actor_started_turn(_affected_actor: Actor, _starting_actor: Actor) -> void:
	pass


## When any actor moves.
## Can be overriden. Should only be used for stat modifiers, since player actors
## can freely move within their move range before doing an action.
func actor_moved(_affected_actor: Actor, _moved_actor: Actor) -> void:
	pass


## When any actor ends its turn.
## Can be overriden.
func actor_ended_turn(_affected_actor: Actor, _ending_actor: Actor) -> void:
	pass
