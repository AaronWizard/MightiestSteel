class_name Stats
extends Node

## An actor's stats

signal stamina_changed(old_stamina: int, new_stamina: int)

## Each stat type
enum StatTypes
{
	MAX_STAMINA, ## An actor's maximum stamina
	ATTACK, ## How much damage an actor's attacks do
	MOVE, ## The max range in cells an actor can move as an action
	SPEED ## Modifies an actor's turn initiative
}


## Each modifier type.
##
## Distinct from stat types as a modifier may affect a value other than a stat,
## such as defence which modifies incoming damage.
enum ModifierTypes
{
	MAX_STAMINA,
	ATTACK,
	MOVE,
	SPEED,
	DEFENCE ## Reduces the amount of damage an actor takes
}


const _STAT_TO_MODIFIER := {
	StatTypes.MAX_STAMINA: ModifierTypes.MAX_STAMINA,
	StatTypes.ATTACK: ModifierTypes.ATTACK,
	StatTypes.MOVE: ModifierTypes.MOVE,
	StatTypes.SPEED: ModifierTypes.SPEED,
}


## An actor's current stamina
var current_stamina: int:
	get:
		return _current_stamina
	set(value):
		var old_stamina := _current_stamina
		_current_stamina = value
		stamina_changed.emit(old_stamina, _current_stamina)


## True if the actor still has stamina left
var is_alive: bool:
	get:
		return current_stamina > 0


## An actor's maximum stamina
var max_stamina: int:
	get:
		return get_stat(StatTypes.MAX_STAMINA)


## How much damage an actor's attacks do
var attack: int:
	get:
		return get_stat(StatTypes.ATTACK)


## The max range in cells an actor can move as an action
var move: int:
	get:
		return get_stat(StatTypes.MOVE)


## Modifies an actor's turn initiative
var speed: int:
	get:
		return get_stat(StatTypes.SPEED)


## How many actions (moves, attacks) an actor may take on its turn
var actions: int:
	get:
		return get_stat(StatTypes.ACTIONS)


var _base_stats := {} # Keys are StatTypes, values are ints
var _current_stamina: int


## Initializes stat values based on an ActorDefinition
func init_from_definition(definition: ActorDefinition) -> void:
	_base_stats[StatTypes.MAX_STAMINA] = definition.stamina
	_base_stats[StatTypes.ATTACK] = definition.attack
	_base_stats[StatTypes.MOVE] = definition.move
	_base_stats[StatTypes.SPEED] = definition.speed

	_current_stamina = definition.stamina


## Get the value of the given type of stat
func get_stat(stat_type: StatTypes) -> int:
	return _base_stats[stat_type]
