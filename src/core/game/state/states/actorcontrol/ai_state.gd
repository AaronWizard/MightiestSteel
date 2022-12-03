class_name AIState
extends ActorControlState


func start(_data: Dictionary) -> void:
	_show_move_range()

	var index := randi_range(0, _game.current_walk_range.move_range.size() - 1)
	var cell := _game.current_walk_range.move_range[index]

	if cell != _current_actor.origin_cell:
		await get_tree().create_timer(0.5).timeout
		await _move_actor(cell)
		_wait()
	else:
		await get_tree().create_timer(0.5).timeout
		_wait()
