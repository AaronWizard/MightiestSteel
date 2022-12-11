class_name ActorControlState
extends GameState

const _ACTION_WAIT_TIME := 0.15

@export var next_turn_state_name: String


static func is_mouse_click(event: InputEvent) -> bool:
	return (event is InputEventMouseButton) \
			and (event.button_index == MOUSE_BUTTON_LEFT) and not event.pressed


func _show_move_range() -> void:
	_current_actor.target_visible = true
	_map_highlights.clear_all()
	_map_highlights.set_move_range(
			_game.current_walk_range.visible_move_range)


func _move_actor(cell: Vector2) -> void:
	_game.camera.dragging_enabled = false
	_game.camera.position_smoothing_enabled = true

	_current_actor.target_visible = false

	var path := _game.current_walk_range.get_move_path(
			_current_actor.origin_cell, cell)
	await _current_actor.move_path(path)


func _run_skill(skill: Skill, target: Vector2i) -> void:
	_game.ui.panels_enabled = false
	_game.camera.dragging_enabled = false

	_current_actor.target_visible = false

	await _current_actor.run_skill(skill, target)
	_end_turn()


func _wait() -> void:
	_game.ui.panels_enabled = false
	_game.camera.dragging_enabled = false

	_end_turn()


func _end_turn() -> void:
	await get_tree().create_timer(_ACTION_WAIT_TIME).timeout
	request_state_change.emit(next_turn_state_name)
