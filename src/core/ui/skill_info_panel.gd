class_name SkillInfoPanel
extends Control

signal cancelled

@onready var _skill_button: Button = $%SkillButton
@onready var _skill_name: Label = $%SkillName
@onready var _no_valid_targets: Control = $%NoValidTargets


func set_skill(skill: Skill, have_valid_targets: bool) -> void:
	_skill_button.icon = skill.icon
	_skill_name.text = skill.name
	_no_valid_targets.visible = not have_valid_targets


func _on_skill_button_pressed() -> void:
	pass # Replace with function body.


func _on_cancel_pressed() -> void:
	cancelled.emit()
