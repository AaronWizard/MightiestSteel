extends Node

signal round_started(is_first_round: bool)
signal actor_started_turn(actor: Actor)
signal actor_finished_turn(actor: Actor)


func emit_round_started(is_first_round: bool) -> void:
	round_started.emit(is_first_round)


func emit_actor_started_turn(actor: Actor) -> void:
	actor_started_turn.emit(actor)


func emit_actor_finished_turn(actor: Actor) -> void:
	actor_finished_turn.emit(actor)
