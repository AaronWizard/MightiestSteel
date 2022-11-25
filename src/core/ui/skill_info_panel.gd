class_name SkillInfoPanel
extends PanelContainer

signal cancelled


var skill_name: String:
	get:
		return _skill_name.text
	set(value):
		_skill_name.text = value


var no_valid_targets: bool:
	get:
		return _no_valid_targets.visible
	set(value):
		_no_valid_targets.visible = value
		reset_size()


@onready var _skill_name: Label = $HBoxContainer/VBoxContainer/SkillName
@onready var _no_valid_targets: Control = $HBoxContainer/VBoxContainer \
		/NoValidTargets


func _on_cancel_pressed() -> void:
	cancelled.emit()
