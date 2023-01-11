class_name StatusEffectNode
extends BaseStatusEffectNode

## An actor's temporary status effects.


class EffectRoundPair:
	## The status effect
	var effect: StatusEffect
	## The number of rounds until the status effect ends
	var rounds_left: int


	func _init(new_effect: StatusEffect) -> void:
		effect = new_effect
		rounds_left = effect.rounds


	var time_left_description: String:
		get:
			var result := ""
			match effect.time_type:
				StatusEffect.TimeType.ROUNDS:
					var round_plural := ""
					if rounds_left > 1:
						round_plural += "s"
					result = "for %d more round%s" % [rounds_left, round_plural]
				StatusEffect.TimeType.NEXT_TURN_START:
					result = "until start of next turn"
				StatusEffect.TimeType.NEXT_TURN_END:
					result = "until end of next turn"
				StatusEffect.TimeType.POSITION:
					result = "at this position"
			return result


signal status_effect_finished(status_effect: StatusEffect)


var effects: Array[EffectRoundPair]:
	get:
		return _effects


var _effects: Array[EffectRoundPair] = []


func _exit_tree() -> void:
	for e in _effects:
		e.effect.removed_from_actor(actor)
	super()


func _get_effects() -> Array[BaseStatusEffect]:
	var result: Array[BaseStatusEffect] = []
	for e in _effects:
		result.append(e.effect)
	return result


func add_effect(status_effect: StatusEffect) -> void:
	_effects.append(EffectRoundPair.new(status_effect))
	status_effect.added_to_actor(actor)


func round_started() -> void:
	await super()
	var finished_effects: Array[EffectRoundPair] = []
	for e in _effects:
		if e.effect.time_type == StatusEffect.TimeType.ROUNDS:
			e.rounds_left -= 1
			if e.rounds_left == 0:
				finished_effects.append(e)
	_processed_finished_effects(finished_effects)


func actor_started_turn(starting_actor: Actor) -> void:
	await super(starting_actor)
	if actor == starting_actor:
		var finished_effects: Array[EffectRoundPair] = []
		for e in _effects:
			if e.effect.time_type == StatusEffect.TimeType.NEXT_TURN_START:
				finished_effects.append(e)
		_processed_finished_effects(finished_effects)


func actor_moved(moved_actor: Actor) -> void:
	super(moved_actor) # Movement effects are not animated
	if actor == moved_actor:
		var finished_effects: Array[EffectRoundPair] = []
		for e in _effects:
			if e.effect.time_type == StatusEffect.TimeType.POSITION:
				finished_effects.append(e)
		_processed_finished_effects(finished_effects)


func actor_ended_turn(ending_actor: Actor) -> void:
	await super(ending_actor)
	if actor == ending_actor:
		var finished_effects: Array[EffectRoundPair] = []
		for e in _effects:
			if e.effect.time_type == StatusEffect.TimeType.NEXT_TURN_END:
				finished_effects.append(e)
		_processed_finished_effects(finished_effects)


func _processed_finished_effects(finished_effects: Array[EffectRoundPair]) \
		-> void:
	for e in finished_effects:
		_effects.erase(e)
		status_effect_finished.emit(e.effect)
