class_name ActorPanel
extends Control


var stats_visible: bool:
	get:
		return _portrait.button_pressed
	set(value):
		_portrait.button_pressed = value


@onready var _portrait: Button = $%Portrait
@onready var _name: Label = $%Name
@onready var _stamina: Range = $%Stamina

@onready var _stats: ActorStatsPanel = $ActorStatsPanel

func set_actor(actor: Actor, enable_portrait: bool) -> void:
	_portrait.icon = actor.portrait
	_name.text = actor.actor_name
	_stamina.max_value = actor.stats.max_stamina
	_stamina.value = actor.stats.current_stamina

	_portrait.disabled = not enable_portrait

	_stats.set_actor(actor)


func clear_actor() -> void:
	_portrait.icon = null
	_portrait.disabled = true


func _on_portrait_toggled(button_pressed: bool) -> void:
	_stats.visible = button_pressed
