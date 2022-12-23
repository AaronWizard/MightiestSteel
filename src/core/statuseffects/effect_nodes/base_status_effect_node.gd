class_name BaseStatusEffectNode
extends Node

## A node for a status effect.
##
## Keeps track of the effect's actor and makes the effect respond to game
## events.
## Not meant to be used in the scene editor.


## The actor the status effect is affecting
var actor: Actor:
	get:
		return _actor


var _actor: Actor


func _init(new_actor: Actor) -> void:
	_actor = new_actor
	_get_effect().added_to_actor(_actor)


func _exit_tree() -> void:
	_actor = null


func _get_effect() -> BaseStatusEffect:
	push_error("BaseStatusEffect: Need to implement _get_effect")
	return null


func round_started() -> void:
	_get_effect().round_started(actor)


func actor_started_turn(starting_actor: Actor) -> void:
	_get_effect().actor_started_turn(actor, starting_actor)


func actor_moved(moved_actor: Actor) -> void:
	_get_effect().actor_moved(actor, moved_actor)


func actor_ended_turn(ending_actor: Actor) -> void:
	_get_effect().actor_ended_turn(actor, ending_actor)
