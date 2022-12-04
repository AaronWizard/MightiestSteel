class_name Game
extends Node

## Manages the current map and battle.
##
## Loads and runs a battle map. Manages turns, keeps track of the current
## actor, and holds the battle's UI.


## The currently loaded map
var current_map: Map:
	get:
		return _current_map


## The actor who is active on the current turn
var current_actor: Actor:
	get:
		return _current_actor


## The movement range of the current actor
var current_walk_range: WalkRange:
	get:
		return get_walk_range(_current_actor)


var map_highlights: MapHighlights:
	get:
		return $MapHighlights


var camera: GameCamera:
	get:
		return $Camera


var ui: GameUI:
	get:
		return $GameUI


var _current_map: Map = null
var _current_actor: Actor = null
var _current_walk_range: WalkRange

@onready var _map_container := $MapContainer

@onready var _turn_manager: TurnManager = $TurnManager

@onready var _state_machine: StateMachine = $StateMachine
@onready var _next_turn_state_name: String = $StateMachine/NextTurnState.name


## Loads the given map scene and starts a battle.
func load_map(new_map_scene: PackedScene) -> void:
	_end_current_actor_turn()

	if _current_map != null:
		_unload_current_map()

	_current_map = new_map_scene.instantiate()
	assert(_current_map != null)
	_map_container.add_child(_current_map)
	_current_map.actor_removed.connect(_turn_manager.remove_actor)
	camera.set_bounds(_current_map.pixel_rect)

	_set_initial_camera_position()
	_start_battle()


func get_walk_range(actor: Actor) -> WalkRange:
	var result: WalkRange
	if actor == _current_actor:
		if not _current_walk_range:
			_current_walk_range = WalkRangeFactory.create_walk_range(
					_current_actor, _current_map)
		result = _current_walk_range
	else:
		result = WalkRangeFactory.create_walk_range(actor, _current_map)
	return result


func advance_to_next_turn() -> void:
	_end_current_actor_turn()
	_current_actor = _turn_manager.advance_to_next_actor()

	if _turn_manager.current_turn_is_round_start:
		_start_round()

	camera.position_smoothing_enabled = true
	_current_actor.remote_transform.remote_path = camera.get_path()
	ui.start_actor_turn(_current_actor)


func _unload_current_map() -> void:
	_map_container.remove_child(_current_map)
	_current_map.actor_removed.disconnect(_turn_manager.remove_actor)
	_current_map.queue_free()
	_current_map = null
	assert(_map_container.get_child_count() == 0)


func _set_initial_camera_position() -> void:
	var center := Vector2.ZERO
	var count := 0

	for a in _current_map.get_actors_by_faction(0):
		center += a.center_cell
		count += 1

	center /= count

	camera.position_smoothing_enabled = false
	camera.position = center * Constants.TILE_SIZE


func _start_battle() -> void:
	_turn_manager.roll_initiative(_current_map.actors)
	_state_machine.change_state(_next_turn_state_name)


func _start_round() -> void:
	_current_map.start_round(_turn_manager.is_first_round)


func _end_current_actor_turn() -> void:
	if _current_actor:
		_current_actor.remote_transform.remote_path = NodePath()
		_current_actor.target_visible = false
	_current_actor = null
	_current_walk_range = null
	map_highlights.clear_all()
	ui.end_current_actor_turn()
