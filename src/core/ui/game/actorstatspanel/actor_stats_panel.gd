class_name ActorStatsPanel
extends PanelContainer

@export var skill_button_scene: PackedScene
@export var skill_button_group: ButtonGroup

@onready var _portrait: TextureRect = $%Portrait
@onready var _name: Label = $%Name

@onready var _current_stamina: Label = $%CurrentStamina
@onready var _max_stamina: Label = $%MaxStamina
@onready var _max_stamina_mod: Label = $%MaxStaminaMod

@onready var _attack: ActorStatsPanelStat = $%Attack
@onready var _move: ActorStatsPanelStat = $%Move
@onready var _speed: ActorStatsPanelStat = $%Speed

@onready var _skills_grid: Control = $%SkillsGrid


func set_actor(actor: Actor) -> void:
	_clear()

	_portrait.texture = actor.portrait
	_name.text = actor.actor_name
	_max_stamina.text = str(actor.stats.max_stamina)
	_current_stamina.text = str(actor.stats.current_stamina)

	_max_stamina_mod.text = ""

	_attack.stat_value = actor.stats.attack
	_move.stat_value = actor.stats.move
	_speed.stat_value = actor.stats.speed

	for s in actor.all_skills:
		var button: ActorStatsPanelSkillButton \
				= skill_button_scene.instantiate()
		_skills_grid.add_child(button)

		button.icon = s.icon
		button.cooldown = actor.get_skill_cooldown(s)
		button.button_group = skill_button_group


func _clear() -> void:
	while _skills_grid.get_child_count() > 0:
		var child := _skills_grid.get_child(0)
		_skills_grid.remove_child(child)
		child.queue_free()
