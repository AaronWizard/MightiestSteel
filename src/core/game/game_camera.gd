class_name GameCamera
extends Camera2D


const _MIN_DRAG_DISTANCE_SQRD := 3 * 3


var dragging_enabled := false:
	set(value):
		dragging_enabled = value
		if not dragging_enabled:
			_dragging = false


var _mouse_down := false
var _first_mouse_down_pos: Vector2
var _dragging := false

@onready var _bounds := self.get_viewport().get_visible_rect()


func _ready() -> void:
	@warning_ignore(return_value_discarded)
	get_tree().root.size_changed.connect(_update_bounds)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_mouse_click(event)
	elif event is InputEventMouseMotion:
		_mouse_move(event as InputEventMouseMotion)


func set_bounds(rect: Rect2i) -> void:
	_bounds = rect
	_update_bounds()


func _mouse_click(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT:
		var event_consumed := true

		if event.pressed:
			_first_mouse_down_pos = event.position
			_mouse_down = true
		else:
			if _mouse_down and not _dragging:
				event_consumed = false
			_mouse_down = false
			_dragging = false

		if event_consumed:
			get_viewport().set_input_as_handled()


func _mouse_move(event: InputEventMouseMotion) -> void:
	if dragging_enabled and _mouse_down:
		if not _dragging:
			_dragging = event.position.distance_squared_to( \
					_first_mouse_down_pos) > _MIN_DRAG_DISTANCE_SQRD
		if _dragging:
			_drag(event.relative)


func _update_bounds() -> void:
	limit_left = int(_bounds.position.x)
	limit_top = int(_bounds.position.y)

	limit_right = int(_bounds.end.x)
	limit_bottom = int(_bounds.end.y)

	var viewport := get_viewport()
	if viewport:
		var view_size := viewport.get_visible_rect().size

		if view_size.x > _bounds.size.x:
			var margin := int((view_size.x - _bounds.size.x) / 2)
			limit_left -= margin
			limit_right += margin

		if view_size.y > _bounds.size.y:
			var margin := int((view_size.y - _bounds.size.y) / 2)
			limit_top -= margin
			limit_bottom += margin


func _drag(relative: Vector2) -> void:
	position_smoothing_enabled = false

	var new_position := position - relative

	var resolution := get_viewport_rect().size
	var half_res := resolution / 2

	new_position.x = maxf(new_position.x, limit_left + half_res.x)
	new_position.x = minf(new_position.x, limit_right - half_res.x)

	new_position.y = maxf(new_position.y, limit_top + half_res.y)
	new_position.y = minf(new_position.y, limit_bottom - half_res.y)

	position = new_position
