@tool
class_name ActorPanel
extends VBoxContainer

const _PORTRAIT_MARGIN_SIDE := -3

@export var skill_button_group: ButtonGroup


@export var reversed := false:
	set(value):
		reversed = value

		if _main_panel and reversed:
			_main_panel.layout_direction = Control.LAYOUT_DIRECTION_RTL
		elif _main_panel and not reversed:
			_main_panel.layout_direction = Control.LAYOUT_DIRECTION_LTR

		if _portrait_margin and reversed:
			_portrait_margin.remove_theme_constant_override("margin_right")
			_portrait_margin.add_theme_constant_override(
					"margin_left", _PORTRAIT_MARGIN_SIDE)
		elif _portrait_margin and not reversed:
			_portrait_margin.remove_theme_constant_override("margin_left")
			_portrait_margin.add_theme_constant_override(
					"margin_right", _PORTRAIT_MARGIN_SIDE)


var enabled: bool:
	get:
		return not _portrait.disabled
	set(value):
		if not value:
			_portrait.button_pressed = false
		_portrait.disabled = not value


@onready var _main_panel: Control = $%MainPanel
@onready var _portrait_margin: MarginContainer = $%PortraitMargin


@onready var _portrait: Button = $%Portrait
@onready var _name: Label = $%Name
@onready var _stamina: Range = $%Stamina

@onready var _stats_container: Control = $%StatsContainer
@onready var _stats: ActorStatsPanel = $%StatsPanel


func _ready() -> void:
	reversed = reversed
	_stats.skill_button_group = skill_button_group


func set_actor(actor: Actor, enable_portrait: bool) -> void:
	_portrait.icon = actor.portrait
	_name.text = actor.actor_name
	_stamina.max_value = actor.stats.max_stamina
	_stamina.value = actor.stats.current_stamina

	enabled = enable_portrait

	_stats.set_actor(actor)


func clear_actor() -> void:
	_portrait.icon = null
	_portrait.disabled = true


func _on_portrait_toggled(button_pressed: bool) -> void:
	_stats_container.visible = button_pressed
