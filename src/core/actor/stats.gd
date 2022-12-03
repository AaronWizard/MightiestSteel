class_name Stats
extends Node


#signal stamina_changed(old_stamina: int, new_stamina: int)
#signal died


enum StatTypes
{
	MAX_STAMINA, ## An actor's maximum stamina
	ATTACK, ## How much damage an actor's attacks do
	MOVE, ## The max range in cells an actor can move as an action
	SPEED, ## Modifies an actor's turn initiative
	ACTIONS ## How many actions (moves, attacks) an actor may take on its turn
}

enum ModifierTypes
{
	MAX_STAMINA,
	ATTACK,
	MOVE,
	SPEED,
	ACTIONS,
	DEFENCE ## Reduces the amount of damage an actor takes
}


const _STAT_TO_MODIFIER := {
	StatTypes.MAX_STAMINA: ModifierTypes.MAX_STAMINA,
	StatTypes.ATTACK: ModifierTypes.ATTACK,
	StatTypes.MOVE: ModifierTypes.MOVE,
	StatTypes.SPEED: ModifierTypes.SPEED,
	StatTypes.ACTIONS: ModifierTypes.ACTIONS
}


## An actor's current stamina
var current_stamina: int:
	get:
		return _current_stamina


var is_alive: bool:
	get:
		return _current_stamina > 0


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


var _base_stats := {}
var _current_stamina: int


func _ready() -> void:
	pass
	#@warning_ignore(return_value_discarded)
	#GameEvents.round_started.connect(self._round_started)


func init_from_definition(definition: ActorDefinition) -> void:
	_base_stats[StatTypes.MAX_STAMINA] = definition.stamina
	_base_stats[StatTypes.ATTACK] = definition.attack
	_base_stats[StatTypes.MOVE] = definition.move
	_base_stats[StatTypes.SPEED] = definition.speed
	_base_stats[StatTypes.ACTIONS] = definition.actions

	_current_stamina = definition.stamina


func get_stat(stat_type: StatTypes) -> int:
	return _base_stats[stat_type]


func predict_damage(attack_power: int) -> int:
	return attack_power


func take_damage(attack_power: int) -> void:
	var old_stamina := _current_stamina

	var damage := predict_damage(attack_power)
	_current_stamina -= damage

	#stamina_changed.emit(old_stamina, _current_stamina)
	#if not is_alive:
		#died.emit()


func _round_started(is_first_round: bool) -> void:
	if is_first_round:
		_current_stamina = get_stat(StatTypes.MAX_STAMINA)
