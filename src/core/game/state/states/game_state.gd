class_name GameState
extends State


@warning_ignore(unused_private_class_variable)
var _current_actor: Actor:
	get:
		return _game.current_actor


@warning_ignore(unused_private_class_variable)
@onready var _game: Game = owner
