class_name StatusEffect
extends Node

signal finished


enum TimeType
{
	## Lasts until X rounds have passed
	ROUNDS,

	## Lasts until start of affected actor's next turn
	NEXT_TURN_START,

	## Lasts until end of affected actor's next turn
	NEXT_TURN_END,

	## Lasts until affected actor moves
	POSITION,

	## Lasts until removed by anything that can remove status effects
	UNTIL_DISPELLED,

	## Does not end
	PASSIVE
}


## Determines when and how status effect will end
@export var time_type := TimeType.ROUNDS

## The number of rounds until the status effect ends. Only applies if time_type
## is TimeType.ROUNDS
@export_range(1, 1, 1, "or_greater") var rounds_left: int


## True if the status effect can be removed by skills.
var can_dispell: bool:
	get:
		return (time_type != TimeType.PASSIVE) \
				and (time_type != TimeType.POSITION)


## The actor this status effect is affecting.
## Not meant ot be set directly. Use Actor.add_status_effect and
## Actor.remove_status_effect.
var actor: Actor:
	get:
		return _actor
	set(value):
		if value and _actor:
			push_error("Status effect already part of an actor")
		elif value and not (self in value.status_effects):
			push_error("Status effect not added using Actor.add_status_effect")
		else:
			if not value:
				_removing_from_actor()

			_actor = value

			if _actor:
				_added_to_actor()


var _actor: Actor = null


func _exit_tree() -> void:
	_removing_from_actor()
	_actor = null


## When a new round has started
func start_round() -> void:
	var active := true
	if time_type == TimeType.ROUNDS:
		rounds_left -= 1
		if rounds_left == 0:
			active = false
			finished.emit()
	if active:
		_round_started()


## When the effect's actor has started its turn
func start_turn() -> void:
	if time_type == TimeType.NEXT_TURN_START:
		finished.emit()


## When the effect's actor has ended its turn
func end_turn() -> void:
	if time_type == TimeType.NEXT_TURN_END:
		finished.emit()


## When the effect's actor has moved
func moved() -> void:
	if time_type == TimeType.POSITION:
		finished.emit()


# Can be overriden
func _added_to_actor() -> void:
	pass


# Can be overriden
func _removing_from_actor() -> void:
	pass


# Can be overriden
func _round_started() -> void:
	pass
