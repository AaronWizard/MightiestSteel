class_name SkillDescriptionPanel
extends PanelContainer

signal cancelled

@onready var _icon: TextureRect = $%Icon
@onready var _name: Label = $%Name
@onready var _cooldown_container: Control = $%CooldownContainer
@onready var _cooldown: Label = $%Cooldown
@onready var _description: Label = $%Description


func set_skill(skill: Skill, need_cooldown: bool) -> void:
	_icon.texture = skill.icon
	_name.text = skill.name
	_cooldown_container.visible = need_cooldown
	_cooldown.text = str(skill.cooldown)
	_description.text = skill.description
	reset_size()


func _on_cancel_pressed() -> void:
	cancelled.emit()
