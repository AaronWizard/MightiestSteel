extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var seed_number := int(Time.get_unix_time_from_system())
	seed(seed_number)
	if OS.is_debug_build():
		print("Random seed: %d" % seed_number)
