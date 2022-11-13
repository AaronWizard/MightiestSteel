class_name Game
extends Node


@export var initial_map: PackedScene


var current_map: Map:
	get:
		return _current_map


var _current_map: Map = null
@onready var _map_container: Node = $MapContainer


func _ready() -> void:
	load_map(initial_map)


func load_map(new_map_scene: PackedScene) -> void:
	if _current_map != null:
		_unload_current_map()

	_current_map = new_map_scene.instantiate()
	assert(_current_map != null)
	_map_container.add_child(_current_map)


func _unload_current_map() -> void:
	_map_container.remove_child(_current_map)
	_current_map.queue_free()
	_current_map = null
	assert(_map_container.get_child_count() == 0)
