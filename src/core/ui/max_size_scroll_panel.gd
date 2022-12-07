@tool
extends Control

enum HAlign { LEFT, CENTER, RIGHT, STRETCH }
enum VAlign { TOP, CENTER, BOTTOM, STRETCH }

const _PANEL_BORDER_SIZE := 6
const _PANEL_BORDER_SIZE_V := Vector2(_PANEL_BORDER_SIZE, _PANEL_BORDER_SIZE)
const _SCROLL_SIZE := 10


@export var halign := HAlign.LEFT:
	set(value):
		halign = value
		_resize_scroll_container()

@export var valign := VAlign.TOP:
	set(value):
		valign = value
		_resize_scroll_container()


@export var horizontal_scroll_mode \
		:= ScrollContainer.ScrollMode.SCROLL_MODE_AUTO:
	get:
		var result := ScrollContainer.ScrollMode.SCROLL_MODE_AUTO
		if _scroll:
			result = _scroll.horizontal_scroll_mode
		return result
	set(value):
		if _scroll:
			_scroll.horizontal_scroll_mode = value
			_resize_scroll_container()


@export var vertical_scroll_mode := ScrollContainer.ScrollMode.SCROLL_MODE_AUTO:
	get:
		var result := ScrollContainer.ScrollMode.SCROLL_MODE_AUTO
		if _scroll:
			result = _scroll.vertical_scroll_mode
		return result
	set(value):
		if _scroll:
			_scroll.vertical_scroll_mode = value
			_resize_scroll_container()


@onready var _panel: Control = $PanelContainer
@onready var _scroll: Control = $PanelContainer/ScrollContainer


func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(Vector2.ZERO, size), Color.RED, false)


func _on_resized() -> void:
	_resize_scroll_container()


func _on_scroll_container_sort_children() -> void:
	_resize_scroll_container()


func _resize_scroll_container() -> void:
	if _scroll:
		if _scroll.get_child_count() > 0:
			var scroll_child = _scroll.get_child(0) # Assumes only one child
			_panel.size = scroll_child.get_minimum_size() + _PANEL_BORDER_SIZE_V
		else:
			_panel.size = _PANEL_BORDER_SIZE_V \
					+ Vector2(_SCROLL_SIZE, _SCROLL_SIZE)

		if _panel.size.x > size.x:
			_panel.size.y += _SCROLL_SIZE
		if _panel.size.y > size.y:
			_panel.size.x += _SCROLL_SIZE

		if halign == HAlign.STRETCH:
			_panel.size.x = size.x
		else:
			_panel.size.x = minf(_panel.size.x, size.x)

		if valign == VAlign.STRETCH:
			_panel.size.y = size.y
		else:
			_panel.size.y = minf(_panel.size.y, size.y)

		_position_panel()


func _position_panel() -> void:
	if _panel:
		match halign:
			HAlign.LEFT:
				_panel.position.x = 0
			HAlign.CENTER:
				_panel.position.x = (size.x - _panel.size.x) / 2.0
			HAlign.RIGHT:
				_panel.position.x = size.x - _panel.size.x

		match valign:
			VAlign.TOP:
				_panel.position.y = 0
			VAlign.CENTER:
				_panel.position.y = (size.y - _panel.size.y) / 2.0
			VAlign.BOTTOM:
				_panel.position.y = size.y - _panel.size.y
