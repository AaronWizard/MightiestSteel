class_name ActorStatsPanel
extends PanelContainer

signal skill_selected(skill: Skill)
signal status_effects_selected(actor: Actor)
signal cancelled

@onready var _portrait: TextureRect = $%Portrait
@onready var _name: Label = $%Name

@onready var _current_stamina: Label = $%CurrentStamina

@onready var _max_stamina: Label = $%MaxStamina
@onready var _max_stamina_mod: Label = $%MaxStaminaMod

@onready var _attack: Label = $%Attack
@onready var _attack_mod: Label = $%AttackMod

@onready var _move: Label = $%Move
@onready var _move_mod: Label = $%MoveMod

@onready var _speed: Label = $%Speed
@onready var _speed_mod: Label = $%SpeedMod

@onready var _skills: Control = $%Skills
@onready var _status_effects: Button = $%StatusEffects

var _actor: Actor


func set_actor(actor: Actor) -> void:
	clear()
	_actor = actor

	_portrait.texture = _actor.portrait
	_name.text = _actor.actor_name
	_current_stamina.text = str(_actor.stats.current_stamina)

	ActorStatsPanel._set_stat_labels(
			_max_stamina, _max_stamina_mod, _actor, Stats.StatTypes.MAX_STAMINA)
	ActorStatsPanel._set_stat_labels(
			_attack, _attack_mod, _actor, Stats.StatTypes.ATTACK)
	ActorStatsPanel._set_stat_labels(
			_move, _move_mod, _actor, Stats.StatTypes.MOVE)
	ActorStatsPanel._set_stat_labels(
			_speed, _speed_mod, _actor, Stats.StatTypes.SPEED)

	assert(_skills.get_child_count() >= _actor.all_skills.size())
	for i in range(_skills.get_child_count()):
		var button: ActorStatsPanelSkillButton = _skills.get_child(i)
		button.visible = i < _actor.all_skills.size()
		if button.visible:
			var skill := _actor.all_skills[i]
			button.icon = skill.icon
			button.cooldown = _actor.get_skill_cooldown(skill)

	_status_effects.visible = _actor.has_cover \
			or _actor.status_effect_nodes.size() > 0


func clear() -> void:
	_actor = null


static func _set_stat_labels(stat_label: Label, stat_mod_label: Label,
		actor: Actor, stat_type: Stats.StatTypes) -> void:
	stat_label.text = str(actor.stats.get_stat(stat_type))

	var mod := actor.stats.get_stat_mod_value(stat_type)
	if mod != 0:
		if mod > 0:
			stat_mod_label.text = "(+%d)" % mod
		else:
			assert(mod < 0)
			stat_mod_label.text = "(%d)" % mod
	else:
		stat_mod_label.text = ""


func _on_cancel_pressed() -> void:
	clear()
	cancelled.emit()


func _on_actor_stats_panel_skill_button_1_pressed() -> void:
	_skill_button_pressed(0)


func _on_actor_stats_panel_skill_button_2_pressed() -> void:
	_skill_button_pressed(1)


func _on_actor_stats_panel_skill_button_3_pressed() -> void:
	_skill_button_pressed(2)


func _on_actor_stats_panel_skill_button_4_pressed() -> void:
	_skill_button_pressed(3)


func _skill_button_pressed(index: int) -> void:
	skill_selected.emit(_actor.all_skills[index])


func _on_status_effects_pressed() -> void:
	status_effects_selected.emit(_actor)
