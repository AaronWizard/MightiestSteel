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


## The turn manager
var turn_manager: TurnManager:
	get:
		return _turn_manager


var _current_map: Map = null
@onready var _map_container := $MapContainer

var _current_actor: Actor = null

@onready var _turn_manager: TurnManager = $TurnManager

@onready var _state_machine: StateMachine = $StateMachine
@onready var _next_turn_state_name: String = $StateMachine/NextTurnState.name


func _ready() -> void:
	@warning_ignore(return_value_discarded)
	GameEvents.actor_started_turn.connect(self._actor_started_turn)
	load_map(initial_map)


func load_map(new_map_scene: PackedScene) -> void:
	_current_actor = null

	if _current_map != null:
		_unload_current_map()

	_current_map = new_map_scene.instantiate()
	assert(_current_map != null)
	_map_container.add_child(_current_map)

	_start_battle.call_deferred()


func _unload_current_map() -> void:
	_map_container.remove_child(_current_map)
	_current_map.queue_free()
	_current_map = null
	assert(_map_container.get_child_count() == 0)


func _start_battle() -> void:
	_turn_manager.roll_initiative(current_map.actors)
	_state_machine.change_state(_next_turn_state_name)


func _actor_started_turn(actor: Actor) -> void:
	_current_actor = actor
