class_name TemporaryStatusEffectNode
extends StatusEffectNode

## A node for a temporary status effect (i.e. not a passive effect).
##
## Keeps track of the effect's actor and makes the effect respond to game
## events.
## Not meant to be used in the scene editor.


signal finished


## The number of rounds until the status effect ends. Only applies if time_type
## is StatusEffect.TimeType.ROUNDS.
var rounds_left: int:
	get:
		return _rounds_left


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


var _time_type: StatusEffect.TimeType
var _rounds_left: int


func _init(new_effect: StatusEffect, new_actor: Actor) -> void:
	super(new_effect, new_actor)
	_time_type = new_effect.time_type



## When a new round has started
func start_round() -> void:
	effect.round_started(actor)

	if effect.time_type == StatusEffect.TimeType.ROUNDS:
		_rounds_left -= 1
		if _rounds_left == 0:
			finished.emit()


## When the effect's actor has started its turn
func start_turn() -> void:
	if effect.time_type == StatusEffect.TimeType.NEXT_TURN_START:
		finished.emit()


## When the effect's actor has ended its turn
func end_turn() -> void:
	if effect.time_type == StatusEffect.TimeType.NEXT_TURN_END:
		finished.emit()


## When the effect's actor has moved
func moved() -> void:
	if effect.time_type == StatusEffect.TimeType.POSITION:
		finished.emit()
