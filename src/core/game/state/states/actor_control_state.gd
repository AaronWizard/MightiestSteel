class_name ActorControlState
extends GameState

@export var next_turn_state_name: String


func _move_actor(cell: Vector2) -> void:
	var path := _game.current_walk_range.get_move_path(
			_game.current_actor.origin_cell, cell)
	for p in path:
		await _game.current_actor.move_step(p)

	request_state_change.emit(next_turn_state_name)


func _wait() -> void:
	GameEvents.emit_actor_finished_turn(_game.current_actor)
	request_state_change.emit(next_turn_state_name)
