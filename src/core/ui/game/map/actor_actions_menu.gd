@tool
class_name ActorActionsMenu
extends Node2D

const _BUTTON_WIDTH := 26
const _SKILL_BUTTON_SEPARATION := _BUTTON_WIDTH + 2


## The actor actions menu events resource that will be sent this menu's actions.
##
## Multiple individual action menus may use the same events resource to allow
## menu events to be detected without connecting to individual menus. Assumes
## only one actor action menu is opened at a time.
@export var menu_events: ActorActionsMenuEvents


## How many skill buttons are visible. Assumes actors have a meximum of 4
## skills.
@export_range(0, 4) var skill_count := 4:
	set(value):
		skill_count = value
		_position_skill_buttons()


## How much separation is between the skill buttons. Used for the open and close
## animations.
@export_range(0, 1) var skill_dist := 0.0:
	set(value):
		skill_dist = value
		_position_skill_buttons()


var rect: Rect2:
	get:
		var result := Rect2()
		if skill_count > 0:
			result.position = _full_rect.get_screen_position()
			result.size = _full_rect.size
		elif _attack_button.visible:
			result.position = _no_skills_rect.get_screen_position()
			result.size = _no_skills_rect.size
		else:
			result.position = _wait_only_rect.get_screen_position()
			result.size = _wait_only_rect.size
		return result


@onready var _attack_button: CanvasItem = $AttackButtonPos
@onready var _skill_buttons: Node = $SkillButtonsPos
@onready var _anim: AnimationPlayer = $AnimationPlayer

@onready var _full_rect: Control = $FullRect
@onready var _no_skills_rect: Control = $NoSkillsRect
@onready var _wait_only_rect: Control = $WaitOnlyRect


func open(actor: Actor) -> void:
	_attack_button.visible = actor.attack_skill != null

	assert(actor.all_skills.size() <= _skill_buttons.get_child_count())
	skill_count = actor.all_skills.size()

	for i in range(skill_count):
		var node_index := _button_node_index(i)
		var skill := actor.all_skills[i]

		var button: Button = _skill_buttons.get_child(node_index).get_child(0)
		button.disabled = not actor.can_run_skill(skill)
		button.icon = skill.icon

		var label: Label = button.get_child(0)
		label.visible = button.disabled
		label.text = str(actor.get_skill_cooldown(skill))

	_anim.play("open")
	await _anim.animation_finished


func close() -> void:
	_anim.play("close")
	await _anim.animation_finished


func _on_attack_button_pressed() -> void:
	if not _anim.is_playing():
		menu_events.attack_selected.emit()


func _on_wait_button_pressed() -> void:
	if not _anim.is_playing():
		menu_events.wait_selected.emit()


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
			var node_index := _button_node_index(i)
			var button: Node2D = _skill_buttons.get_child(node_index)

			button.visible = i < skill_count
			var button_x := ((_SKILL_BUTTON_SEPARATION * i) - button_shift) \
					* skill_dist
			button.position.x = button_x


func _button_node_index(index: int) -> int:
	return _skill_buttons.get_child_count() - index - 1


func _skill_selected(skill_index: int) -> void:
	if not _anim.is_playing():
		menu_events.skill_selected.emit(skill_index)
