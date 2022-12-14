class_name StatusEffect
extends Resource

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


@export var icon: Texture2D


## Determines when and how status effect will end
@export var time_type := TimeType.ROUNDS
## The number of rounds until the status effect ends. Only applies if time_type
## is TimeType.ROUNDS.
@export_range(1, 1, 1, "or_greater") var rounds := 1


## A description string of the status effect.
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


## When a new round has started.
## Can be overriden.
func round_started(_actor: Actor) -> void:
	pass
