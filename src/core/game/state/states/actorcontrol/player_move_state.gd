class_name PlayerMoveState
extends ActorControlState

## The actor actions menu events resource for detecting action menu events
## without connecting to any actor's individual menu. Assumes only one actor
## action menu is opened at a time.
@export var menu_events: ActorActionsMenuEvents

## The name of the state node for player skill targeting
@export var player_target_state_name: String

var _other_actor: Actor


func _ready() -> void:
	menu_events.attack_selected.connect(_attack_selected)
	menu_events.skill_selected.connect(_skill_selected)
	menu_events.wait_selected.connect(_wait_selected)

	await owner.ready

	_game.ui.turn_queue.clicked.connect(func(actor: Actor):
		if actor == _current_actor:
			if not actor.center_on_screen:
				_game.camera.position_smoothing_enabled = true
				_game.camera.position = _current_actor.center_position
		else:
			_toggle_other_actor_lighlight(actor, true)
	)


func start(_data: Dictionary) -> void:
	_game.camera.dragging_enabled = true
	_game.ui.panels_enabled = true

	_show_move_range()


func end() -> void:
	_clear_other_actor(false, true)


func handle_unhandled_input(event: InputEvent) -> void:
	if ActorControlState.is_mouse_click(event):
		if _current_actor.action_menu.visible:
			_action_menu_input()
		else:
			_choose_move_input()


func _choose_move_input() -> void:
	var cell := _game.current_map.mouse_cell
	if _current_actor.is_on_cell(cell):
		_start_action_menu()
	elif _game.current_walk_range.in_move_range(cell):
		_do_move(cell)
	else:
		_try_select_other_actor(cell)


func _start_action_menu() -> void:
	_game.camera.dragging_enabled = false
	allow_input = false

	var rect = _current_actor.action_menu.rect

	var camera_shift := Vector2.ZERO
	var screen_rect := _game.ui.play_area

	if rect.position.x < 0:
		camera_shift.x = rect.position.x - 1
	elif rect.end.x > screen_rect.size.x:
		camera_shift.x = rect.end.x - screen_rect.size.x

	if rect.position.y < 0:
		camera_shift.y = rect.position.y
	elif rect.end.y > screen_rect.size.y:
		camera_shift.y = rect.end.y - screen_rect.size.y - 1

	_game.camera.position_smoothing_enabled = true
	_game.camera.position += camera_shift

	await _current_actor.open_action_menu()
	allow_input = true # Clicking away from action menu closes it


func _do_move(cell: Vector2i) -> void:
	allow_input = false
	_clear_other_actor(false, true)
	await _move_actor(cell)
	_game.camera.dragging_enabled = true
	_current_actor.target_visible = true
	allow_input = true


func _try_select_other_actor(cell: Vector2i) -> void:
	var other_actor := _game.current_map.get_actor_on_cell(cell)
	_toggle_other_actor_lighlight(other_actor, false)


func _toggle_other_actor_lighlight(other_actor: Actor, move_camera: bool) \
		-> void:
	if other_actor and (other_actor != _current_actor) \
			and (other_actor != _other_actor):
		_highlight_other_actor(other_actor)
	else:
		_clear_other_actor(move_camera, true)


func _highlight_other_actor(actor: Actor) -> void:
	assert(actor != _current_actor)
	_clear_other_actor(false, false)
	_other_actor = actor

	_other_actor.other_target_visible = true
	_game.ui.show_other_actor(_other_actor)
	_game.ui.turn_queue.other_actor_name = _other_actor.name

	if not _other_actor.center_on_screen:
		_game.camera.position_smoothing_enabled = true
		_game.camera.position = _other_actor.center_position


	var move := _game.get_walk_range(_other_actor).visible_move_range
	var threat_range := _game.get_threat_range(_other_actor)

	var targets: Array[Vector2i] = []
	targets.assign(threat_range.targets)

	var aoe: Array[Vector2i] = []
	aoe.assign(threat_range.aoe)

	_map_highlights.set_other_range(move, targets, aoe)


func _clear_other_actor(move_camera: bool, clear_turn_queue: bool) -> void:
	if _other_actor != null:
		_map_highlights.clear_other_range()
		_game.ui.hide_other_actor()

		if clear_turn_queue:
			# Will scroll turn queue to current turn actor
			_game.ui.turn_queue.other_actor_name = ""

		_other_actor.other_target_visible = false
		_other_actor = null

		if move_camera and not _current_actor.center_on_screen:
			_game.camera.position_smoothing_enabled = true
			_game.camera.position = _current_actor.center_position


func _action_menu_input() -> void:
	allow_input = false
	# Clicked outside of action menu
	await _current_actor.close_action_menu()
	allow_input = true
	_game.camera.dragging_enabled = true


func _start_choose_target(skill: Skill, need_cooldown: bool) -> void:
	_game.camera.dragging_enabled = false
	allow_input = false
	await _current_actor.close_action_menu()

	request_state_change.emit(player_target_state_name,
			{skill = skill, need_cooldown = need_cooldown})


func _attack_selected() -> void:
	_start_choose_target(_current_actor.attack_skill, false)


func _skill_selected(skill_index: int) -> void:
	_start_choose_target(_current_actor.all_skills[skill_index], true)


func _wait_selected() -> void:
	allow_input = false
	await _current_actor.close_action_menu()
	_wait()
