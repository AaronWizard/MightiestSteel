class_name TurnQueueItem
extends Control

signal clicked


var portrait: Texture2D:
	get:
		return _portrait.texture
	set(value):
		_portrait.texture = value


var actor_name: String:
	get:
		return _name.text
	set(value):
		_name.text = value


var is_current: bool:
	get:
		return _current_turn_border.visible
	set(value):
		_current_turn_border.visible = value


var is_other: bool:
	get:
		return _other_turn_border.visible
	set(value):
		_other_turn_border.visible = value


@onready var _portrait: TextureRect = $HBoxContainer/Portrait
@onready var _name: Label = $HBoxContainer/Name

@onready var _current_turn_border: Control = $BorderCurrent
@onready var _other_turn_border: Control = $BorderOther


func _gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton) \
			and (event.button_index == MOUSE_BUTTON_LEFT) and not event.pressed:
		clicked.emit()


func reset_other_border() -> void:
	_other_turn_border.visible = false
