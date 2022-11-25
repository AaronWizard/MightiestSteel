class_name ActorControlState
extends GameState

const _ACTION_WAIT_TIME := 0.15

@export var next_turn_state_name: String


func _move_actor(cell: Vector2) -> void:
	_game.current_actor.target_visible = false
	var path := _game.current_walk_range.get_move_path(
			_game.current_actor.origin_cell, cell)
	await _game.current_actor.move_path(path)


func _wait() -> void:
	_end_turn()


func _end_turn() -> void:
	await get_tree().create_timer(_ACTION_WAIT_TIME).timeout
	GameEvents.emit_actor_finished_turn(_game.current_actor)
	request_state_change.emit(next_turn_state_name)
