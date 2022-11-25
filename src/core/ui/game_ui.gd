class_name GameUI
extends CanvasLayer


signal skill_cancelled


@onready var _cancel_skill_button: CanvasItem = $CancelSkill


var cancel_skill_visible: bool:
	get:
		return _cancel_skill_button.visible
	set(value):
		_cancel_skill_button.visible = value


func _on_cancel_skill_pressed() -> void:
	skill_cancelled.emit()
