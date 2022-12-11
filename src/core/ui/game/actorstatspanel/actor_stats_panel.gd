class_name ActorStatsPanel
extends PanelContainer

signal skill_selected(skill: Skill)
signal skill_cleared

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

var last_pressed_button: Button = null


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

	for skill in actor.all_skills:
		var button: ActorStatsPanelSkillButton \
				= skill_button_scene.instantiate()
		_skills_grid.add_child(button)

		button.icon = skill.icon
		button.cooldown = actor.get_skill_cooldown(skill)
		button.button_group = skill_button_group

		button.toggled.connect(func(button_pressed: bool):
			if last_pressed_button == button:
				button.set_pressed_no_signal(false)
				last_pressed_button = null
			else:
				last_pressed_button = button

			var group_button := skill_button_group.get_pressed_button()
			if not group_button:
				skill_cleared.emit()
			elif group_button == button:
				skill_selected.emit(skill)
		)


func _clear() -> void:
	last_pressed_button = null
	while _skills_grid.get_child_count() > 0:
		var child := _skills_grid.get_child(0)
		_skills_grid.remove_child(child)
		child.queue_free()
