extends Node

signal round_started(is_first_round: bool)
signal actor_started_turn(actor: Actor)
signal actor_finished_turn(actor: Actor)

signal actor_died(actor: Actor)
