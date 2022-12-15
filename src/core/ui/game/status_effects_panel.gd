@tool
class_name StatusEffectsPanel
extends MaxSizeScrollPanel

signal cancelled

@onready var _effects_list: Control = $%EffectsList


func set_actor(actor: Actor) -> void:
	_clear()

	if actor.has_cover:
		_add_line(
			Constants.STAT_MODS[Stats.ModifierTypes.DEFENCE].up,
			"+%d%% defence from cover" % roundi(Map.COVER_DEFENCE_BONUS * 100)
		)

	for s in actor.status_effect_nodes:
		var text := "%s %s" \
				% [s.effect.get_description(), s.time_left_description]
		_add_line(s.effect.icon, text)


func _add_line(icon_texture: Texture2D, text: String) -> void:
	var line := HBoxContainer.new()

	if icon_texture:
		var icon:= TextureRect.new()
		icon.texture = icon_texture
		icon.stretch_mode = TextureRect.STRETCH_KEEP
		line.add_child(icon)

	var description := Label.new()
	description.text = text
	description.size_flags_horizontal = Control.SizeFlags.SIZE_EXPAND_FILL
	line.add_child(description)

	_effects_list.add_child(line)


func _clear() -> void:
	while _effects_list.get_child_count() > 0:
		var line := _effects_list.get_child(0)
		_effects_list.remove_child(line)
		line.queue_free()


func _on_cancel_pressed() -> void:
	cancelled.emit()
