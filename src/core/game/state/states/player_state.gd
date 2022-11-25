class_name PlayerState
extends ActorControlState


enum _InnerState
{
	CHOOSE_MOVE,
	ACTION_MENU,
	CHOOSE_TARGET
}

var _inner_state: _InnerState = _InnerState.CHOOSE_MOVE

var _target_data: SkillTargetsData


func start(data: Dictionary) -> void:
	super(data)

	_current_actor.action_menu.attack_selected.connect(_attack_selected)
	_current_actor.action_menu.skill_selected.connect(_skill_selected)
	_current_actor.action_menu.wait_selected.connect(_wait_selected)
	_game.ui.skill_cancelled.connect(_start_skill_ended)


func end() -> void:
	_current_actor.action_menu.attack_selected.disconnect(_attack_selected)
	_current_actor.action_menu.skill_selected.disconnect(_skill_selected)
	_current_actor.action_menu.wait_selected.disconnect(_wait_selected)

	_game.ui.skill_cancelled.disconnect(_start_skill_ended)

	_target_data = null

	_game.ui.cancel_skill_visible = false

	super()


func handle_unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("click", true):
		match _inner_state:
			_InnerState.CHOOSE_MOVE:
				_choose_move_input()
			_InnerState.ACTION_MENU:
				_action_menu_input()


func _show_move_range() -> void:
	super()
	_inner_state = _InnerState.CHOOSE_MOVE


func _choose_move_input() -> void:
	var cell := _game.current_map.mouse_cell
	if _current_actor.is_on_cell(cell):
		_start_action_menu()
	elif _game.current_walk_range.in_move_range(cell):
		allow_input = false
		await _move_actor(cell)
		_current_actor.target_visible = true
		allow_input = true


func _start_action_menu() -> void:
	_current_actor.open_action_menu()
	_inner_state = _InnerState.ACTION_MENU


func _action_menu_input() -> void:
	# Clicked outside of action menu
	await _current_actor.close_action_menu()
	_inner_state = _InnerState.CHOOSE_MOVE


func _start_choose_target(skill: Skill) -> void:
	await _current_actor.close_action_menu()
	_current_actor.target_visible = false

	_target_data = skill.get_targeting_data(_current_actor)

	_game.map_highlights.clear_all()
	_game.map_highlights.set_target_range(
			_target_data.target_range, _target_data.valid_targets)
	_game.ui.cancel_skill_visible = true

	_inner_state = _InnerState.CHOOSE_TARGET


func _attack_selected() -> void:
	_start_choose_target(_current_actor.attack_skill)


func _skill_selected(skill_index: int) -> void:
	_start_choose_target(_current_actor.all_skills[skill_index])


func _start_skill_ended() -> void:
	_game.ui.cancel_skill_visible = false
	_show_move_range()


func _wait_selected() -> void:
	await _current_actor.close_action_menu()
	_wait()
