class_name SkillInfoPanel
extends HBoxContainer

signal icon_pressed(skill: Skill, need_cooldown: bool)
signal cancelled

@onready var _skill_button: Button = $%SkillButton
@onready var _skill_name: Label = $%SkillName
@onready var _no_valid_targets: Control = $%NoValidTargets


func set_skill(skill: Skill, need_cooldown: bool, have_valid_targets: bool) \
		-> void:
	_skill_button.icon = skill.icon
	_skill_name.text = skill.name
	_no_valid_targets.visible = not have_valid_targets

	UIUtils.remove_signal_connections(_skill_button.pressed)
	_skill_button.pressed.connect(
		func(): icon_pressed.emit(skill, need_cooldown)
	)


func _on_cancel_pressed() -> void:
	cancelled.emit()
