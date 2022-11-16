class_name NextTurnState
extends GameState

## Advances to either the game's win/lose condition or to the next actor's turn


func _ready() -> void:
	@warning_ignore(return_value_discarded)
	GameEvents.actor_started_turn.connect(self._actor_started_turn)


func start(_data: Dictionary) -> void:
	_game.turn_manager.next_turn()


func _actor_started_turn(actor: Actor) -> void:
	if actor.is_player_controlled:
		pass
	else:
		pass