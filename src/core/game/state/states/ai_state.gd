class_name AIState
extends ActorControlState


func start(_data: Dictionary) -> void:
	print("ai started")

	var index := randi_range(0, _game.current_walk_range.move_range.size() - 1)
	var cell := _game.current_walk_range.move_range[index]

	if cell != _game.current_actor.origin_cell:
		await get_tree().create_timer(0.25).timeout
		_move_actor(cell)
	else:
		await get_tree().create_timer(0.25).timeout
		_wait()
