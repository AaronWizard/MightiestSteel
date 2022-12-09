class_name ActorStatsPanel
extends PanelContainer


@onready var _portrait: TextureRect = $%Portrait
@onready var _name: Label = $%Name

@onready var _stamina_bar: Range = $%StaminaBar
@onready var _current_stamina: Label = $%CurrentStamina

@onready var _max_stamina: Label = $%MaxStamina
@onready var _max_stamina_mod: Label = $%MaxStaminaMod

@onready var _attack: ActorStatsPanelStat = $%Attack
@onready var _move: ActorStatsPanelStat = $%Move
@onready var _speed: ActorStatsPanelStat = $%Speed


func set_actor(actor: Actor) -> void:
	_portrait.texture = actor.portrait
	_name.text = actor.actor_name
	_stamina_bar.max_value = actor.stats.max_stamina
	_stamina_bar.value = actor.stats.current_stamina
	_max_stamina.text = str(actor.stats.max_stamina)
	_current_stamina.text = str(actor.stats.current_stamina)

	_max_stamina_mod.text = ""

	_attack.stat_value = actor.stats.attack
	_move.stat_value = actor.stats.move
	_speed.stat_value = actor.stats.speed
