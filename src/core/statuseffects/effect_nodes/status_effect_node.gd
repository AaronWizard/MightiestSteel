class_name StatusEffectNode
extends BaseStatusEffectNode

## A node for a temporary status effect.
##
## Not meant to be used in the scene editor.


signal finished


var effect: StatusEffect:
	get:
		return _effect


## The number of rounds until the status effect ends. Only applies if time_type
## is StatusEffect.TimeType.ROUNDS.
var rounds_left: int:
	get:
		return _rounds_left


var _effect: StatusEffect
var _rounds_left: int


func _init(new_effect: StatusEffect, new_actor: Actor) -> void:
	_effect = new_effect
	_rounds_left = _effect.rounds
	tree_exited.connect(func(): _effect.removed_from_actor(new_actor))
	super(new_actor)


func _get_effect() -> BaseStatusEffect:
	return _effect


func round_started() -> void:
	super()
	if effect.time_type == StatusEffect.TimeType.ROUNDS:
		_rounds_left -= 1
		if _rounds_left == 0:
			finished.emit()


func actor_started_turn(starting_actor: Actor) -> void:
	super(starting_actor)
	if (actor == starting_actor) \
			and (effect.time_type == StatusEffect.TimeType.NEXT_TURN_START):
		finished.emit()


func actor_moved(moved_actor: Actor) -> void:
	super(moved_actor)
	if (actor == moved_actor) \
			and (effect.time_type == StatusEffect.TimeType.POSITION):
		finished.emit()


func actor_ended_turn(ending_actor: Actor) -> void:
	super(ending_actor)
	if (actor == ending_actor) \
			and (effect.time_type == StatusEffect.TimeType.NEXT_TURN_END):
		finished.emit()
