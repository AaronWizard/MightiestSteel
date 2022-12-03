class_name NextTurnState
extends GameState

## Advances to either the game's win/lose condition or to the next actor's turn

@export var player_state: String
@export var ai_state: String


func start(_data: Dictionary) -> void:
	_game.advance_to_next_turn()

	if _current_actor.is_player_controlled:
		request_state_change.emit(player_state)
	else:
		request_state_change.emit(ai_state)
