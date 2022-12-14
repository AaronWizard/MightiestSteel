class_name ActorStatusEffectIcons
extends Node2D

var _icon_index := 0


func _ready() -> void:
	GlobalActorIconTimer.timeout.connect(_on_global_icon_anim_timer_timeout)


func update_icons(actor: Actor) -> void:
	_clear()

	for t in Constants.STAT_MODS:
		_add_stat_mod_icon(actor, t)

	for s in actor.status_effect_nodes:
		_add_status_effect_icon(s.effect)

	if get_child_count() > 1:
		_icon_index = (GlobalActorIconTimer.index % get_child_count()) - 1
	else:
		_icon_index = 0
	_on_global_icon_anim_timer_timeout()


func _add_stat_mod_icon(actor: Actor, mod_type: Stats.ModifierTypes) -> void:
	var mod := actor.stats.get_modifier(mod_type)
	if (mod_type == Stats.ModifierTypes.DEFENCE) and actor.has_cover:
		mod += Map.COVER_DEFENCE_BONUS

	if mod != 0:
		var icon := Sprite2D.new()
		if mod > 0:
			icon.texture = Constants.STAT_MODS[mod_type].up
		else:
			icon.texture = Constants.STAT_MODS[mod_type].down
		add_child(icon)


func _add_status_effect_icon(effect: StatusEffect) -> void:
	if effect.icon and not effect is StatModEffect:
		var icon := Sprite2D.new()
		icon.texture = effect.icon
		add_child(icon)


func _clear() -> void:
	while get_child_count() > 0:
		var c := get_child(0)
		remove_child(c)
		c.queue_free()


func _on_global_icon_anim_timer_timeout() -> void:
	if get_child_count() > 1:
		_icon_index = (_icon_index + 1) % get_child_count()
		for i in range(get_child_count()):
			var icon: CanvasItem = get_child(i)
			icon.visible = i == _icon_index
	elif get_child_count() == 1:
		var icon: CanvasItem = get_child(0)
		icon.visible = GlobalActorIconTimer.toggle
