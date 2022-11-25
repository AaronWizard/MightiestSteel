class_name PlayerState
extends ActorControlState


enum _InnerState
{
	CHOOSE_MOVE,
	ACTION_MENU,
	CHOOSE_TARGET
}

var _inner_state: _InnerState = _InnerState.CHOOSE_MOVE

var _selected_skill: Skill
var _target_data: SkillTargetsData


func start(data: Dictionary) -> void:
	super(data)

	_current_actor.action_menu.attack_selected.connect(_attack_selected)
	_current_actor.action_menu.skill_selected.connect(_skill_selected)
	_current_actor.action_menu.wait_selected.connect(_wait_selected)

	_game.ui.skill_info_panel.cancelled.connect(_start_skill_ended)

	_game.camera.dragging_enabled = true


func end() -> void:
	_current_actor.action_menu.attack_selected.disconnect(_attack_selected)
	_current_actor.action_menu.skill_selected.disconnect(_skill_selected)
	_current_actor.action_menu.wait_selected.disconnect(_wait_selected)

	_game.ui.skill_info_panel.cancelled.disconnect(_start_skill_ended)

	_selected_skill = null
	_target_data = null

	_game.ui.skill_info_panel.visible = false
	_game.camera.dragging_enabled = false

	super()


func handle_unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton) \
			and (event.button_index == MOUSE_BUTTON_LEFT) and not event.pressed:
		match _inner_state:
			_InnerState.CHOOSE_MOVE:
				_choose_move_input()
			_InnerState.ACTION_MENU:
				_action_menu_input()
			_InnerState.CHOOSE_TARGET:
				_choose_target_input()


func _show_move_range() -> void:
	super()
	allow_input = true
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
	_game.camera.dragging_enabled = false
	allow_input = false

	var rect = _current_actor.action_menu.rect

	var camera_shift := Vector2.ZERO
	var screen_rect := _current_actor.action_menu.get_viewport_rect()

	if rect.position.x < 0:
		camera_shift.x = rect.position.x - 2
	elif rect.end.x > screen_rect.size.x:
		camera_shift.x = rect.end.x - screen_rect.size.x + 1

	if rect.position.y < 0:
		camera_shift.y = rect.position.y - 2
	elif rect.end.y > screen_rect.size.y:
		camera_shift.y = rect.end.y - screen_rect.size.y + 1

	print(_game.camera.position)

	_game.camera.position_smoothing_enabled = true
	_game.camera.position += camera_shift
	print(_game.camera.position)

	print(rect)
	await _current_actor.open_action_menu()

	_inner_state = _InnerState.ACTION_MENU
	allow_input = true


func _action_menu_input() -> void:
	allow_input = false
	# Clicked outside of action menu
	await _current_actor.close_action_menu()
	_inner_state = _InnerState.CHOOSE_MOVE
	allow_input = true
	_game.camera.dragging_enabled = true


func _start_choose_target(skill: Skill) -> void:
	_game.camera.dragging_enabled = false
	allow_input = false
	await _current_actor.close_action_menu()
	allow_input = true
	_game.camera.dragging_enabled = true

	_current_actor.target_visible = false

	_selected_skill = skill
	_target_data = skill.get_targeting_data(_current_actor)

	_map_highlights.clear_all()
	_map_highlights.set_target_range(
			_target_data.target_range, _target_data.valid_targets)

	_game.ui.skill_info_panel.skill_name = skill.name
	_game.ui.skill_info_panel.no_valid_targets = \
			_target_data.valid_targets.is_empty()
	_game.ui.skill_info_panel.visible = true

	_inner_state = _InnerState.CHOOSE_TARGET


func _choose_target_input() -> void:
	var cell := _game.current_map.mouse_cell
	if _map_highlights.target_cursor.visible \
			and (_map_highlights.target_cursor.origin_cell == cell):
		_map_highlights.target_cursor.visible = false
		_run_skill(_selected_skill, _map_highlights.target_cursor.origin_cell)
	elif _target_data.is_valid_target(cell):
		_map_highlights.target_cursor.visible = true
		_map_highlights.target_cursor.origin_cell = cell


func _attack_selected() -> void:
	_start_choose_target(_current_actor.attack_skill)


func _skill_selected(skill_index: int) -> void:
	_start_choose_target(_current_actor.all_skills[skill_index])


func _start_skill_ended() -> void:
	_game.ui.skill_info_panel.visible = false
	_map_highlights.target_cursor.visible = false
	_show_move_range()


func _wait_selected() -> void:
	allow_input = false
	await _current_actor.close_action_menu()
	_wait()
