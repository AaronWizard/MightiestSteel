class_name StatusEffect
extends BaseStatusEffect

## Temporary status effect on actor.

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
	UNTIL_DISPELLED
}


## The effect's icon in an actor's status effects panel. Assumed to be 8x8.
## Can be dynamic.
@export var icon: Texture2D:
	get:
		return _get_icon()
	set(value):
		_set_icon(value)


## Determines when and how status effect will end
@export var time_type := TimeType.ROUNDS
## The number of rounds until the status effect ends. Only applies if time_type
## is TimeType.ROUNDS.
@export_range(1, 1, 1, "or_greater") var rounds := 1


var _icon: Texture2D


## A description string of the status effect. Can be dynamic.
## Can be overriden.
func get_description() -> String:
	return ""


## When the status effect is first added to the actor.
## Can be overriden.
func added_to_actor(_actor: Actor) -> void:
	pass


## When the status effect is being removed from the actor.
## Can be overriden.
func removing_from_actor(_actor: Actor) -> void:
	pass


## Can be overriden.
func _set_icon(value: Texture2D) -> void:
	_icon = value


## Can be overriden.
func _get_icon() -> Texture2D:
	return _icon
