class_name Stats
extends Node

## An actor's stats

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


signal stamina_changed(old_stamina: int, new_stamina: int)
signal stat_mod_changed(mod_type: ModifierTypes)


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


var _current_stamina: int
var _base_stats := {} # Keys are StatTypes, values are ints
var _modifiers: Array[StatModifier] = []


## Initializes stat values based on an ActorDefinition
func init_from_definition(definition: ActorDefinition) -> void:
	_base_stats[StatTypes.MAX_STAMINA] = definition.stamina
	_base_stats[StatTypes.ATTACK] = definition.attack
	_base_stats[StatTypes.MOVE] = definition.move
	_base_stats[StatTypes.SPEED] = definition.speed

	_current_stamina = definition.stamina


## Get the value of the given type of stat
func get_stat(stat_type: StatTypes) -> int:
	var base: int = _base_stats[stat_type]
	var modifier_type: ModifierTypes = _STAT_TO_MODIFIER[stat_type]
	var mod := get_modifier(modifier_type)
	var result = int(float(base) * (1.0 + mod))
	return result


func get_modifier(modifier_type: ModifierTypes) -> float:
	var result := 0.0
	for m in _modifiers:
		if m.mod_type == modifier_type:
			result += m.mod_value
	return result


func add_modifier(modifier: StatModifier) -> void:
	if not modifier in _modifiers:
		_modifiers.append(modifier)
		stat_mod_changed.emit(modifier.mod_type)
	else:
		push_warning("Stat already has modifier '%s'" % modifier.resource_path)


func remove_modifier(modifier: StatModifier) -> void:
	_modifiers.erase(modifier)
	stat_mod_changed.emit(modifier.mod_type)
