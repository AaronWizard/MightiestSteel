class_name SkillInfoPanel
extends VBoxContainer

signal cancelled

@onready var _skill_button: Button = $%SkillButton
@onready var _skill_name: Label = $%SkillName
@onready var _no_valid_targets: Control = $%NoValidTargets

@onready var _description_container: Control = $%DescriptionContainer
@onready var _cooldown_header: Control = $%CooldownHeader
@onready var _cooldown: Label = $%Cooldown
@onready var _description: Label = $%Description


func set_skill(skill: Skill, has_cooldown: bool, have_valid_targets: bool) \
		-> void:
	_skill_button.icon = skill.icon
	_skill_name.text = skill.name

	_cooldown_header.visible = has_cooldown
	_cooldown.text = str(skill.cooldown)
	_description.text = skill.description

	_no_valid_targets.visible = not have_valid_targets

	_skill_button.button_pressed = false


func _on_cancel_pressed() -> void:
	cancelled.emit()


func _on_skill_button_toggled(button_pressed: bool) -> void:
	_description_container.visible = button_pressed
