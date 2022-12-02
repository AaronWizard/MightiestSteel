class_name PlayerTargetState
extends ActorControlState

@export var player_move_state_name: String


var _selected_skill: Skill
var _target_data: SkillTargetsData


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

	_selected_skill = null
	_target_data = null


func handle_unhandled_input(event: InputEvent) -> void:
	if ActorControlState.is_mouse_click(event):
		var cell := _game.current_map.mouse_cell
		if _map_highlights.target_cursor.visible \
				and (_map_highlights.target_cursor.origin_cell == cell):
			_start_run_skill()
		elif _target_data.is_valid_target(cell):
			_map_highlights.target_cursor.visible = true
			_map_highlights.target_cursor.origin_cell = cell


func _start_run_skill() -> void:
	_map_highlights.target_cursor.visible = false
	_map_highlights.clear_all()
	_game.ui.skill_info_panel.visible = false
	_run_skill(_selected_skill, _map_highlights.target_cursor.origin_cell)


func _start_skill_ended() -> void:
	request_state_change.emit(player_move_state_name)
