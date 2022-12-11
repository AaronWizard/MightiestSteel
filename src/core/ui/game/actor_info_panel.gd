@tool
class_name ActorInfoPanel
extends HBoxContainer

signal portrait_pressed

const _PORTRAIT_MARGIN_SIDE := -3


@export var reversed := false:
	set(value):
		reversed = value
		if _portrait_margin:
			if reversed:
				move_child(_portrait_margin, get_child_count() - 1)
				_portrait_margin.remove_theme_constant_override("margin_right")
				_portrait_margin.add_theme_constant_override(
						"margin_left", _PORTRAIT_MARGIN_SIDE)
			else:
				move_child(_portrait_margin, 0)
				_portrait_margin.remove_theme_constant_override("margin_left")
				_portrait_margin.add_theme_constant_override(
						"margin_right", _PORTRAIT_MARGIN_SIDE)


var enabled: bool:
	get:
		return not _portrait.disabled
	set(value):
		_portrait.disabled = not value


@onready var _portrait_margin: MarginContainer = $%PortraitMargin
@onready var _portrait: Button = $%Portrait
@onready var _name: Label = $%Name
@onready var _stamina: Range = $%Stamina


func set_actor(actor: Actor, enable_portrait: bool) -> void:
	_portrait.icon = actor.portrait
	_name.text = actor.actor_name
	_stamina.max_value = actor.stats.max_stamina
	_stamina.value = actor.stats.current_stamina

	enabled = enable_portrait


func _on_portrait_pressed() -> void:
	portrait_pressed.emit()
