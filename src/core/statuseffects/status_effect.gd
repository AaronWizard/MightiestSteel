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
var time_type: TimeType

## The number of rounds until the status effect ends. Only applies if time_type
## is TimeType.ROUNDS
var rounds_left: int


## True if the status effect can be removed by skills.
var can_dispell: bool:
	get:
		return (time_type != TimeType.PASSIVE) \
				and (time_type != TimeType.POSITION)


func start_round() -> void:
	if time_type == TimeType.ROUNDS:
		rounds_left -= 1
		if rounds_left == 0:
			finished.emit()


func start_turn() -> void:
	if time_type == TimeType.NEXT_TURN_START:
		finished.emit()


func end_turn() -> void:
	if time_type == TimeType.NEXT_TURN_END:
		finished.emit()


func moved() -> void:
	if time_type == TimeType.POSITION:
		finished.emit()
