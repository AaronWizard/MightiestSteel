extends Node

@export var initial_map: PackedScene

@onready var _game: Game = $Game


func _ready() -> void:
	_init_rand()
	_game.load_map(initial_map)


func _init_rand() -> void:
	var seed_number := 1669755221#int(Time.get_unix_time_from_system())
	seed(seed_number)
	if OS.is_debug_build():
		print("Random seed: %d" % seed_number)
