@tool
class_name ActorActionsMenu
extends Node2D

signal attack_selected
signal skill_selected(skill_index: int)
signal wait_selected


const _BUTTON_WIDTH := 26
const _SKILL_BUTTON_SEPARATION := _BUTTON_WIDTH + 2


@export_range(0, 4) var skill_count := 4:
	set(value):
		skill_count = value
		_position_skill_buttons()


@export_range(0, 1) var skill_dist := 0.0:
	set(value):
		skill_dist = value
		_position_skill_buttons()


#@onready var _attack_button: CanvasItem = $AttackButtonPos
@onready var _skill_buttons: Node = $SkillButtonsPos
@onready var _anim: AnimationPlayer = $AnimationPlayer


func open() -> void:
	_anim.play("open")
	await _anim.animation_finished


func close() -> void:
	_anim.play("close")
	await _anim.animation_finished


func _on_attack_button_pressed() -> void:
	if not _anim.is_playing():
		attack_selected.emit()


func _on_wait_button_pressed() -> void:
	wait_selected.emit()


func _on_skill_button_1_pressed() -> void:
	_skill_selected(0)


func _on_skill_button_2_pressed() -> void:
	_skill_selected(1)


func _on_skill_button_3_pressed() -> void:
	_skill_selected(2)


func _on_skill_button_4_pressed() -> void:
	_skill_selected(3)


func _position_skill_buttons() -> void:
	var button_shift := (_SKILL_BUTTON_SEPARATION * (skill_count - 1)) / 2.0
	if _skill_buttons:
		for i in range(0, _skill_buttons.get_child_count()):
			var node_index := _skill_buttons.get_child_count() - i - 1
			var button: Node2D = _skill_buttons.get_child(node_index)

			button.visible = i < skill_count
			var button_x := ((_SKILL_BUTTON_SEPARATION * i) - button_shift) \
					* skill_dist
			button.position.x = button_x


func _skill_selected(skill_index: int) -> void:
	if not _anim.is_playing():
		skill_selected.emit(skill_index)
