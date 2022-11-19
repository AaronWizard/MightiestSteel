class_name PlayerState
extends ActorControlState


var _blocking_input := false


func start(_data: Dictionary) -> void:
	_blocking_input = false


func handle_unhandled_input(_event: InputEvent) -> void:
	if not _blocking_input and Input.is_action_pressed("click", true):
		var cell := _game.current_map.mouse_cell
		if (cell != _game.current_actor.origin_cell) \
				and _game.current_walk_range.in_move_range(cell):
			_blocking_input = true
			await _move_actor(cell)
			_blocking_input = false
