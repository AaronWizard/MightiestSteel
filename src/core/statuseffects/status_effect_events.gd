class_name StatusEffectEvents
extends Resource

## Makes status effects respond to game events.


func round_started() -> void:
	pass


func actor_started_turn(actor: Actor) -> void:
	pass


func actor_moved(actor: Actor) -> void:
	pass


func actor_ended_turn(actor: Actor) -> void:
	pass
