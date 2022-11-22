class_name PlayerState
extends ActorControlState


enum _InnerState
{
	CHOOSE_MOVE,
	ACTION_MENU
}


var _inner_state: _InnerState = _InnerState.CHOOSE_MOVE


func start(_data: Dictionary) -> void:
	_inner_state = _InnerState.CHOOSE_MOVE

	@warning_ignore(return_value_discarded)
	_game.current_actor.action_menu.attack_selected.connect(_attack_selected)
	@warning_ignore(return_value_discarded)
	_game.current_actor.action_menu.skill_selected.connect(_skill_selected)
	@warning_ignore(return_value_discarded)
	_game.current_actor.action_menu.wait_selected.connect(_wait_selected)


func end() -> void:
	_game.current_actor.action_menu.attack_selected.disconnect(_attack_selected)
	_game.current_actor.action_menu.skill_selected.disconnect(_skill_selected)
	_game.current_actor.action_menu.wait_selected.disconnect(_wait_selected)


func handle_unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("click", true):
		match _inner_state:
			_InnerState.CHOOSE_MOVE:
				_choose_move()
			_InnerState.ACTION_MENU:
				_action_menu()


func _choose_move() -> void:
	var cell := _game.current_map.mouse_cell
	if _game.current_actor.is_on_cell(cell):
		_game.current_actor.open_action_menu()
		_inner_state = _InnerState.ACTION_MENU
	elif _game.current_walk_range.in_move_range(cell):
		allow_input = false
		await _move_actor(cell)
		allow_input = true


func _action_menu() -> void:
	# Clicked outside of action menu
	await _game.current_actor.close_action_menu()
	_inner_state = _InnerState.CHOOSE_MOVE


func _attack_selected() -> void:
	await _game.current_actor.close_action_menu()


func _skill_selected(_skill_index: int) -> void:
	await _game.current_actor.close_action_menu()


func _wait_selected() -> void:
	await _game.current_actor.close_action_menu()
	_wait()
