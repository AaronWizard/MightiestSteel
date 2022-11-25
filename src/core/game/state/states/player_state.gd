class_name PlayerState
extends ActorControlState


enum _InnerState
{
	CHOOSE_MOVE,
	ACTION_MENU,
	CHOOSE_TARGET
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
	assert(not _game.ui.skill_cancelled.is_connected(_start_skill_ended))
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
	_start_skill_selected(_game.current_actor.attack_skill)


func _skill_selected(skill_index: int) -> void:
	_start_skill_selected(_game.current_actor.all_skills[skill_index])


func _start_skill_selected(skill: Skill) -> void:
	await _game.current_actor.close_action_menu()

	var targeting_data = skill.get_targeting_data(_game.current_actor)

	_game.map_highlights.clear_all()
	_game.map_highlights.set_target_range(targeting_data.target_range, targeting_data.valid_targets)

	_game.ui.cancel_skill_visible = true
	_game.ui.skill_cancelled.connect(
			_start_skill_ended, ConnectFlags.CONNECT_ONE_SHOT)

	_inner_state = _InnerState.CHOOSE_TARGET


func _start_skill_ended() -> void:
	_game.ui.cancel_skill_visible = false
	_inner_state = _InnerState.CHOOSE_MOVE


func _wait_selected() -> void:
	await _game.current_actor.close_action_menu()
	_wait()
