class_name PlayerTargetState
extends ActorControlState

@export var player_move_state_name: String


var _current_target: Vector2i:
	get:
		return _map_highlights.target_cursor.origin_cell


var _selected_skill: Skill
var _target_data: SkillTargetsData

var _predicted_damage_actors: Array[Actor]


func start(data: Dictionary) -> void:
	_game.ui.skill_info_panel.cancelled.connect(_start_skill_ended)

	_selected_skill = data.skill
	_target_data = _selected_skill.get_targeting_data(_current_actor)

	_game.camera.dragging_enabled = true
	_current_actor.target_visible = false

	_map_highlights.clear_all()
	_map_highlights.set_target_range(
			_target_data.target_range, _target_data.valid_targets)

	_game.ui.skill_info_panel.set_skill(
			_selected_skill, not _target_data.valid_targets.is_empty())
	_game.ui.skill_info_panel.visible = true


func end() -> void:
	_game.ui.skill_info_panel.cancelled.disconnect(_start_skill_ended)
	_game.ui.skill_info_panel.visible = false
	_map_highlights.target_cursor.visible = false

	_clear_predicted_damage()

	_selected_skill = null
	_target_data = null


func handle_unhandled_input(event: InputEvent) -> void:
	if ActorControlState.is_mouse_click(event):
		var cell := _game.current_map.mouse_cell
		if _map_highlights.target_cursor.visible and (_current_target == cell):
			_start_run_skill()
		elif _target_data.is_valid_target(cell):
			_set_target(cell)


func _set_target(cell: Vector2i) -> void:
	_map_highlights.target_cursor.visible = true
	_map_highlights.target_cursor.origin_cell = cell
	_show_predicted_damage()


func _show_predicted_damage() -> void:
	_clear_predicted_damage()
	var target_info := _target_data.get_target_info(_current_target)
	_predicted_damage_actors = target_info.predicted_damage.keys()
	for a in _predicted_damage_actors:
		a.stamina_bar_modifier = -target_info.predicted_damage[a]


func _clear_predicted_damage() -> void:
	for a in _predicted_damage_actors:
		a.stamina_bar_modifier = 0
	_predicted_damage_actors.clear()


func _start_run_skill() -> void:
	_map_highlights.target_cursor.visible = false
	_map_highlights.clear_all()
	_game.ui.skill_info_panel.visible = false
	_clear_predicted_damage()
	_run_skill(_selected_skill, _current_target)


func _start_skill_ended() -> void:
	request_state_change.emit(player_move_state_name)
