class_name StatusEffectNode
extends Node

## A node containing a status effect applied to an actor.
##
## Keeps track of the effect's actor and makes the effect respond to game
## events.
## Not meant to be used in the scene editor.

signal finished


var effect: StatusEffect:
	get:
		return _effect


# ToDo: Determine whether or not status effect node needs an internal actor
# reference vs having the actor passed in its methods.

## The actor the status effect is affecting
var actor: Actor:
	get:
		return _actor


## The number of rounds until the status effect ends. Only applies if time_type
## is StatusEffect.TimeType.ROUNDS.
var rounds_left:
	get:
		return _rounds_left


## True if the status effect can be removed by skills.
var can_dispell: bool:
	get:
		return (effect.time_type != StatusEffect.TimeType.PASSIVE) \
				and (effect.time_type != StatusEffect.TimeType.POSITION)


var _effect: StatusEffect
var _actor: Actor
var _rounds_left: int


func _init(new_effect: StatusEffect, new_actor: Actor) -> void:
	_effect = new_effect
	_actor = new_actor
	_rounds_left = _effect.rounds


func _exit_tree() -> void:
	effect.removing_from_actor(_actor)
	_actor = null


## When a new round has started
func start_round() -> void:
	var active := true
	if effect.time_type == StatusEffect.TimeType.ROUNDS:
		_rounds_left -= 1
		if _rounds_left == 0:
			active = false
			finished.emit()
	if active:
		effect.round_started(actor)


## When the effect's actor has started its turn
func start_turn() -> void:
	if effect.time_type == StatusEffect.TimeType.NEXT_TURN_START:
		finished.emit()


## When the effect's actor has ended its turn
func end_turn() -> void:
	if effect.time_type == StatusEffect.TimeType.NEXT_TURN_END:
		finished.emit()


## When the effect's actor has moved
func moved() -> void:
	if effect.time_type == StatusEffect.TimeType.POSITION:
		finished.emit()
