class_name Game
extends Node


@export var initial_map: PackedScene


## The currently loaded map
var current_map: Map:
	get:
		return _current_map


## The actor who is active on the current turn
var current_actor: Actor:
	get:
		return _current_actor


var current_walk_range: WalkRange:
	get:
		return get_walk_range(_current_actor)


var map_highlights: MapHighlights:
	get:
		return _map_highlights


## The turn manager
var turn_manager: TurnManager:
	get:
		return _turn_manager


var _current_map: Map = null
var _current_actor: Actor = null

# Keys are actors, values are WalkRanges
var _walk_ranges := {}

@onready var _map_container := $MapContainer
@onready var _map_highlights := $MapHighlights
@onready var _turn_manager: TurnManager = $TurnManager

@onready var _state_machine: StateMachine = $StateMachine
@onready var _next_turn_state_name: String = $StateMachine/NextTurnState.name


func _ready() -> void:
	@warning_ignore(return_value_discarded)
	GameEvents.actor_started_turn.connect(self._actor_started_turn)
	load_map(initial_map)


func load_map(new_map_scene: PackedScene) -> void:
	_clear_turn_data()

	if _current_map != null:
		_unload_current_map()

	_current_map = new_map_scene.instantiate()
	assert(_current_map != null)
	_map_container.add_child(_current_map)

	_start_battle()


func get_walk_range(actor: Actor) -> WalkRange:
	if not _walk_ranges.has(actor):
		_walk_ranges[actor] = WalkRangeFactory.create_walk_range(
				actor, _current_map)
	return _walk_ranges[actor]


func _unload_current_map() -> void:
	_map_container.remove_child(_current_map)
	_current_map.queue_free()
	_current_map = null
	assert(_map_container.get_child_count() == 0)


func _start_battle() -> void:
	_turn_manager.roll_initiative(_current_map.actors)
	_state_machine.change_state(_next_turn_state_name)


func _actor_started_turn(actor: Actor) -> void:
	_clear_turn_data()
	_current_actor = actor

	map_highlights.set_move_range(current_walk_range.visible_move_range)


func _clear_turn_data() -> void:
	_current_actor = null
	_walk_ranges.clear()
