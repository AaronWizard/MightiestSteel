class_name SkillInfoPanel
extends HBoxContainer

signal icon_pressed(skill: Skill, need_cooldown: bool)
signal cancelled

@onready var _skill_button: Button = $%SkillButton
@onready var _skill_name: Label = $%SkillName
@onready var _no_valid_targets: Control = $%NoValidTargets


func set_skill(skill: Skill, have_valid_targets: bool) -> void:
	_skill_button.icon = skill.icon
	_skill_name.text = skill.name
	_no_valid_targets.visible = not have_valid_targets

	while not _skill_button.pressed.get_connections().is_empty():
		var connection_data: Dictionary \
				= _skill_button.pressed.get_connections()[0]
		var callable: Callable = connection_data.callable
		_skill_button.pressed.disconnect(callable)

	_skill_button.pressed.connect(func(): icon_pressed.emit(skill, true) )


func _on_skill_button_pressed() -> void:
	pass


func _on_cancel_pressed() -> void:
	cancelled.emit()
