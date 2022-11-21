class_name PlayerState
extends ActorControlState


func handle_unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("click", true):
		var cell := _game.current_map.mouse_cell
		if (cell != _game.current_actor.origin_cell) \
				and _game.current_walk_range.in_move_range(cell):
			allow_input = false
			await _move_actor(cell)
			allow_input = true
