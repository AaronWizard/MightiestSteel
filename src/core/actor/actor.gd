@tool
class_name Actor
extends TileObject

signal moved
signal attack_hit


@export var sprite_texture: Texture2D:
	get:
		return _sprite.texture
	set(value):
		if _sprite:
			_sprite.texture = value


## Name of actor instance, independant of actor's node name.
@export var actor_name := "Actor"

## Faction ID. All factions are hostile to each other.
## A faction ID of 0 is controlled by the player.
@export var faction := 0

@export var definition: ActorDefinition

@export_group("Animation")


@export var cell_offset_direction := Vector2.ZERO:
	set(value):
		cell_offset_direction = value
		_set_offset()


@export var cell_offset_distance := 0.0:
	set(value):
		cell_offset_distance = value
		_set_offset()


## Change actor's origin cell without changing its visible position nor
## triggering position-based events. Used for predicting skill effects.
var virtual_origin_cell: Vector2i:
	get:
		var result := origin_cell
		if _using_virtual_origin_cell:
			result = _virtual_origin_cell
		return result
	set(value):
		if value != origin_cell:
			_virtual_origin_cell = value
			_using_virtual_origin_cell = true


## The actor's stats
var stats: Stats:
	get:
		return $Stats


## The map the actor is currently on.
## Not meant to be set directly. Use Map.add_actor and Map.remove_actor to
## change an actor's map.
var map: Map:
	set(value):
		if map and (self in map.actors):
			push_error("Actor not removed from old map using Map.remove_actor")
		if value and not (self in value.actors):
			push_error("Actor not added to new map using Map.add_actor")
		map = value


## True if the actor is controlled by the player.
## An actor is player-controlled if its faction is 0.
var is_player_controlled: bool:
	get:
		return faction == 0


var remote_transform: RemoteTransform2D:
	get:
		return $Center/Offset/RemoteTransform2D


## Flip the sprite in the direction of the given vector
var facing: Vector2:
	set(value):
		if value.x < 0:
			_sprite.flip_h = true
		elif value.x > 0:
			_sprite.flip_h = false
		# else change nothing


var target_visible: bool:
	get:
		return _target_cursor.visible
	set(value):
		_target_cursor.visible = value


var action_menu: ActorActionsMenu:
	get:
		return $Center/ActorActionsMenu


var _virtual_origin_cell := Vector2i.ZERO
var _using_virtual_origin_cell := false

var _report_moves := true

@onready var _sprite: Sprite2D = $Center/Offset/Sprite
@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _offset: Node2D = $Center/Offset

@onready var _target_cursor: TileObject = $TargetCursor


func _ready() -> void:
	if not Engine.is_editor_hint():
		if definition:
			stats.init_from_definition(definition)
		_target_cursor.cell_size = cell_size


func _exit_tree() -> void:
	map = null


func open_action_menu() -> void:
	action_menu.visible = true
	await action_menu.open()


func close_action_menu() -> void:
	await action_menu.close()
	action_menu.visible = false


func unset_virtual_origin_cell() -> void:
	_virtual_origin_cell = Vector2.ZERO
	_using_virtual_origin_cell = false


func move_step(target_cell: Vector2i) -> void:
	assert((target_cell - origin_cell).length_squared() == 1)

	facing = target_cell
	cell_offset_direction = target_cell - origin_cell
	cell_offset_distance = -1
	origin_cell = target_cell

	_anim.play("move_step")
	await _anim.animation_finished


func _set_offset() -> void:
	if _offset:
		_offset.position = cell_offset_direction.normalized() \
				* cell_offset_distance * Constants.TILE_SIZE


func _update_size() -> void:
	super()
	if _target_cursor:
		_target_cursor.cell_size = cell_size


func _get_origin_cell() -> Vector2i:
	if _using_virtual_origin_cell:
		return virtual_origin_cell
	else:
		return super()


func _set_origin_cell(cell: Vector2i) -> void:
	unset_virtual_origin_cell()
	super(cell)
	if _report_moves:
		moved.emit()
