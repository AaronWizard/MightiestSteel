class_name GameState
extends State


@warning_ignore(unused_private_class_variable)
var _current_actor: Actor:
	get:
		return _game.current_actor


var _map_highlights: MapHighlights:
	get:
		return _game.map_highlights


@onready var _game: Game = owner
