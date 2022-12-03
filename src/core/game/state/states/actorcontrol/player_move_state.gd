class_name PlayerMoveState
extends ActorControlState

## The actor actions menu events resource for detecting action menu events
## without connecting to any actor's individual menu. Assumes only one actor
## action menu is opened at a time.
@export var menu_events: ActorActionsMenuEvents \
		= preload("res://src/core/ui/map/actor_actions_menu_events.tres")

@export var player_target_state_name: String


func _ready() -> void:
	menu_events.attack_selected.connect(_attack_selected)
	menu_events.skill_selected.connect(_skill_selected)
	menu_events.wait_selected.connect(_wait_selected)


func start(_data: Dictionary) -> void:
	_game.camera.dragging_enabled = true
	_show_move_range()


func end() -> void:
	_game.ui.skill_info_panel.visible = false
	_game.camera.dragging_enabled = false


func handle_unhandled_input(event: InputEvent) -> void:
	if ActorControlState.is_mouse_click(event):
		if _current_actor.action_menu.visible:
			_action_menu_input()
		else:
			_choose_move_input()


func _show_move_range() -> void:
	_current_actor.target_visible = true
	_map_highlights.clear_all()
	_map_highlights.set_move_range(
			_game.current_walk_range.visible_move_range)


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

	_game.camera.position_smoothing_enabled = true
	_game.camera.position += camera_shift

	await _current_actor.open_action_menu()
	allow_input = true # Clicking away from action menu closes it


func _action_menu_input() -> void:
	allow_input = false
	# Clicked outside of action menu
	await _current_actor.close_action_menu()
	allow_input = true
	_game.camera.dragging_enabled = true


func _start_choose_target(skill: Skill) -> void:
	_game.camera.dragging_enabled = false
	allow_input = false
	await _current_actor.close_action_menu()

	request_state_change.emit(player_target_state_name, {skill = skill})


func _attack_selected() -> void:
	_start_choose_target(_current_actor.attack_skill)


func _skill_selected(skill_index: int) -> void:
	_start_choose_target(_current_actor.all_skills[skill_index])


func _wait_selected() -> void:
	allow_input = false
	await _current_actor.close_action_menu()
	_wait()
