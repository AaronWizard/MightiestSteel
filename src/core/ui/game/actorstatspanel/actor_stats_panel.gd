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

@onready var _attack: ActorStatsPanelStat = $%Attack
@onready var _move: ActorStatsPanelStat = $%Move
@onready var _speed: ActorStatsPanelStat = $%Speed

@onready var _skills_grid: Control = $%SkillsGrid
@onready var _status_effects: Button = $%StatusEffects

var _actor: Actor


func set_actor(actor: Actor) -> void:
	clear()
	_actor = actor

	_portrait.texture = _actor.portrait
	_name.text = _actor.actor_name
	_max_stamina.text = str(_actor.stats.max_stamina)
	_current_stamina.text = str(_actor.stats.current_stamina)

	_max_stamina_mod.text = ""

	_attack.stat_value = _actor.stats.attack
	_move.stat_value = _actor.stats.move
	_speed.stat_value = _actor.stats.speed

	assert(_skills_grid.get_child_count() >= _actor.all_skills.size())
	for i in range(_skills_grid.get_child_count()):
		var button: ActorStatsPanelSkillButton = _skills_grid.get_child(i)
		button.visible = i < _actor.all_skills.size()
		if button.visible:
			var skill := _actor.all_skills[i]
			button.icon = skill.icon
			button.cooldown = _actor.get_skill_cooldown(skill)

	_status_effects.visible = _actor.has_cover \
			or _actor.status_effect_nodes.size() > 0


func clear() -> void:
	_actor = null


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
