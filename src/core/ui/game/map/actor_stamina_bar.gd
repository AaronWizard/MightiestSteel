class_name ActorStaminaBar
extends Node2D

const _CHANGE_PER_SECOND := 0.1
const _CHANGE_DELAY := 0.25


var max_stamina: int:
	get:
		return int(_stamina.max_value)
	set(value):
		_stamina.max_value = value
		_change.max_value = value


var modifier := 0:
	set(value):
		modifier = value

		_stamina.value = _current_value
		_change.value = _current_value

		if modifier > 0:
			_change.value += modifier
		elif modifier < 0:
			_stamina.value += modifier

		_modifier_label.text = str(value)
		_modifier_label.visible = modifier != 0


var _current_value: int


@onready var _change: Range = $Change
@onready var _stamina: Range = $Stamina
@onready var _modifier_label: Label = $ModifierLabel


func set_to_full() -> void:
	_current_value = max_stamina
	_stamina.value = max_stamina


func animate_change(delta: int) -> void:
	modifier = 0

	var old_stamina := _current_value
	_current_value = clampi(
			_current_value + delta, 0, max_stamina)

	if delta < 0:
		_stamina.value = _current_value
		await _animate_bar(_change, old_stamina, _current_value)
	else:
		_change.value = _current_value
		await _animate_bar(_stamina, old_stamina, _current_value)


func _animate_bar(bar: Range, old_value: int, new_value: int) -> void:
	bar.value = old_value

	var time := absf(new_value - old_value) * _CHANGE_PER_SECOND
	var tween := get_tree().create_tween()
	tween.tween_property(bar, "value", new_value, time) \
			.set_delay(_CHANGE_DELAY)
	tween.tween_interval(_CHANGE_DELAY)
	await tween.finished
