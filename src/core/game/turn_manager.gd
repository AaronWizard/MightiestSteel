class_name TurnManager
extends Node

@export var game_events: GameEvents = preload(
		"res://src/core/game/game_events.tres")


class _Turn:
	const SPEED_MOD_MIN := 1
	const SPEED_MOD_MAX := 20

	var actor: Actor
	var speed_mod: int


	var rank: int:
		get:
			return speed_mod


	func _init(new_actor) -> void:
		actor = new_actor
		speed_mod = randi_range(SPEED_MOD_MIN, SPEED_MOD_MAX)


	static func compare(a: _Turn, b: _Turn) -> bool:
		var result := false

		if a.rank > b.rank:
			result = true
		elif (a.rank == b.rank) and a.actor.is_player_controlled \
				and not b.actor.is_player_controlled:
			# Player actors go first if all else are equal
			result = true

		return result


var _turns: Array[_Turn] = []
var _turn_index := 0


func _ready() -> void:
	pass


func roll_initiative(actors: Array[Actor]) -> void:
	_turns.clear()
	_turn_index = 0

	for a in actors:
		var turn := _Turn.new(a)
		_turns.append(turn)

	_turns.sort_custom(Callable(_Turn, "compare"))

	for t in _turns:
		print("'%s': %d" % [t.actor.name, t.rank])


func next_turn() -> void:
	_turn_index = (_turn_index + 1) % _turns.size()
	if _turn_index == 0:
		game_events.emit_round_started()

	var turn := _turns[_turn_index]
	game_events.emit_actor_started_turn(turn.actor)
