@tool
class_name StatusEffectsPanel
extends MaxSizeScrollPanel

signal cancelled

@onready var _effects_list: Control = $%EffectsList


func set_actor(actor: Actor) -> void:
	_clear()

	if actor.has_cover:
		_add_label("+%d%% defence from cover"
				% roundi(Map.COVER_DEFENCE_BONUS * 100))

	for s in actor.status_effect_nodes:
		var text := "%s %s" \
				% [s.effect.get_description(), s.time_left_description]
		_add_label(text)


func _add_label(text: String) -> void:
	var line := Label.new()
	line.text = text
	_effects_list.add_child(line)


func _clear() -> void:
	while _effects_list.get_child_count() > 0:
		var line := _effects_list.get_child(0)
		_effects_list.remove_child(line)
		line.queue_free()


func _on_cancel_pressed() -> void:
	cancelled.emit()
