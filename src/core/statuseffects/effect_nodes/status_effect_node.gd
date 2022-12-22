class_name StatusEffectNode
extends Node

## A node containing a status effect applied to an actor.
##
## Not meant to be used in the scene editor.


var effect: BaseStatusEffect:
	get:
		return _effect


## The actor the status effect is affecting
var actor: Actor:
	get:
		return _actor


var _effect: BaseStatusEffect
var _actor: Actor


func _init(new_effect: BaseStatusEffect, new_actor: Actor) -> void:
	_effect = new_effect
	_actor = new_actor
	effect.added_to_actor(_actor)


func _exit_tree() -> void:
	_actor = null


func round_started() -> void:
	effect.round_started(actor)


func actor_started_turn(starting_actor: Actor) -> void:
	effect.actor_started_turn(actor, starting_actor)


func actor_moved(moved_actor: Actor) -> void:
	effect.actor_moved(actor, moved_actor)


func actor_ended_turn(ending_actor: Actor) -> void:
	effect.actor_ended_turn(actor, ending_actor)
