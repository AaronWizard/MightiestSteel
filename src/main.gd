extends Node

@export_range(1, 1, 1, "or_greater") var base_screen_size := 180

@onready var game_viewport: SubViewport = $SubViewportContainer/SubViewport


func _ready() -> void:
	_init_rand()
	_init_screen()


func _init_rand() -> void:
	var seed_number := 1668745511#int(Time.get_unix_time_from_system())
	seed(seed_number)
	if OS.is_debug_build():
		print("Random seed: %d" % seed_number)


func _init_screen() -> void:
	_size_changed()
	@warning_ignore(return_value_discarded)
	get_tree().root.size_changed.connect(_size_changed)


func _size_changed() -> void:
	var window_size := get_tree().root.size
	var min_dimension := mini(window_size.x, window_size.y)
	var scale := float(base_screen_size) / float(min_dimension)
	game_viewport.size_2d_override = Vector2i(window_size * scale)
	print(game_viewport.size_2d_override)
