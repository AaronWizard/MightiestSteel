class_name BaseStatusEffectNode
extends Node

## A node for a set of status effects attached to an actor.
##
## Keeps track of the effect's actor and makes the effect respond to game
## events.


@export var status_effect_events: StatusEffectEvents


## The actor the status effect is affecting
var actor: Actor:
	get:
		return owner


func _ready() -> void:
	status_effect_events.add_effect_node(self)


func _exit_tree() -> void:
	status_effect_events.remove_effect_node(self)


# To be overriden
func _get_effects() -> Array[BaseStatusEffect]:
	push_error("BaseStatusEffect: Need to implement _get_effect")
	return []


func round_started() -> void:
	var calls: Array[Callable] = []
	for e in _get_effects():
		calls.append(e.round_started.bind(actor))
	await AwaitGroup.wait(calls)


func actor_started_turn(starting_actor: Actor) -> void:
	var calls: Array[Callable] = []
	for e in _get_effects():
		calls.append(e.actor_started_turn.bind(actor, starting_actor))
	await AwaitGroup.wait(calls)


func actor_moved(moved_actor: Actor) -> void:
	# Movement effects are not animated
	var calls: Array[Callable] = []
	for e in _get_effects():
		calls.append(e.actor_moved.bind(actor, moved_actor))
	AwaitGroup.wait(calls)


func actor_starting_move(moved_actor: Actor) -> void:
	# Movement effects are not animated
	var calls: Array[Callable] = []
	for e in _get_effects():
		calls.append(e.actor_starting_move.bind(actor, moved_actor))
	AwaitGroup.wait(calls)


func actor_finished_move(moved_actor: Actor) -> void:
	# Movement effects are not animated
	var calls: Array[Callable] = []
	for e in _get_effects():
		calls.append(e.actor_finished_move.bind(actor, moved_actor))
	AwaitGroup.wait(calls)


func actor_ended_turn(ending_actor: Actor) -> void:
	var calls: Array[Callable] = []
	for e in _get_effects():
		calls.append(e.actor_ended_turn.bind(actor, ending_actor))
	await AwaitGroup.wait(calls)
