class_name TurnManager
extends Node


## Manages actor turns.
##
## Keeps track of the order that actors get a turn and of the current turn.
## Distinguishes between turns - which represent an individual actor's turn -
## and rounds - which represent the full set of turns for all actors.


class _Turn:
	const SPEED_MOD_MIN := 1
	const SPEED_MOD_MAX := 20

	var actor: Actor
	var speed_mod: int


	var rank: int:
		get:
			return speed_mod + actor.stats.speed


	func _init(new_actor) -> void:
		actor = new_actor
		speed_mod = randi_range(SPEED_MOD_MIN, SPEED_MOD_MAX)


## True if the current turn is the first turn in the round
var current_turn_is_round_start: bool:
	get:
		return _turn_index == 0


## True if the current round is the first round since rolling initiative
var is_first_round: bool:
	get:
		return _is_first_round


var _turns: Array[_Turn] = []
var _turn_index := -1
var _is_first_round := true


func roll_initiative(actors: Array[Actor]) -> void:
	_turns.clear()
	_turn_index = -1
	_is_first_round = true

	for a in actors:
		var turn := _Turn.new(a)
		_turns.append(turn)

	_turns.sort_custom(_compare_turns)


## Advances to the next turn and get the actor taking this turn
func advance_to_next_actor() -> Actor:
	if (_turn_index + 1) == _turns.size():
		_is_first_round = false
	_turn_index = (_turn_index + 1) % _turns.size()
	var turn := _turns[_turn_index]
	return turn.actor


## Removes the actor from the turn order. Preseres tracking of the current turn.
func remove_actor(actor: Actor) -> void:
	var turns_to_remove: Array[_Turn] = []
	for i in range(_turns.size()):
		var turn := _turns[i]
		if turn.actor == actor:
			turns_to_remove.append(turn)
			if i < _turn_index:
				_turn_index -= 1
	for t in turns_to_remove:
		_turns.erase(t)


static func _compare_turns(a: _Turn, b: _Turn) -> bool:
	var compare_rank := a.rank > b.rank
	var compare_speed := a.actor.stats.speed > b.actor.stats.speed
	var compare_is_player := a.actor.is_player_controlled \
			and not b.actor.is_player_controlled

	return compare_rank \
			or (not compare_rank and compare_speed) \
			or (not compare_rank and not compare_speed and compare_is_player)
