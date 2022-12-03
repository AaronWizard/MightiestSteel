class_name TurnManager
extends Node


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


var _turns: Array[_Turn] = []
var _turn_index := -1


func _ready() -> void:
	pass
	#GameEvents.actor_died.connect(_actor_died)


func roll_initiative(actors: Array[Actor]) -> void:
	_turns.clear()
	_turn_index = -1

	for a in actors:
		var turn := _Turn.new(a)
		_turns.append(turn)

	_turns.sort_custom(_compare_turns)


func advance_to_next_actor() -> Actor:
	_turn_index = (_turn_index + 1) % _turns.size()
	var turn := _turns[_turn_index]
	return turn.actor


static func _compare_turns(a: _Turn, b: _Turn) -> bool:
	var compare_rank := a.rank > b.rank
	var compare_speed := a.actor.stats.speed > b.actor.stats.speed
	var compare_is_player := a.actor.is_player_controlled \
			and not b.actor.is_player_controlled

	return compare_rank \
			or (not compare_rank and compare_speed) \
			or (not compare_rank and not compare_speed and compare_is_player)


func _actor_died(actor: Actor) -> void:
	var turns_to_remove: Array[_Turn] = []
	for i in range(_turns.size()):
		var turn := _turns[i]
		if turn.actor == actor:
			turns_to_remove.append(turn)
			if i < _turn_index:
				_turn_index -= 1
	for t in turns_to_remove:
		_turns.erase(t)
