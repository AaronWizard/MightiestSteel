@tool
class_name Actor
extends TileObject


signal attack_hit

@export var sprite_texture: Texture2D:
	get:
		return _sprite.texture
	set(value):
		if _sprite:
			_sprite.texture = value

## Name of actor instance.
@export var actor_name := "Actor"

## Faction ID. All factions are hostile to each other.
@export var faction := 0

@export_group("Animation")

@export var cell_offset_direction := Vector2.ZERO:
	set(value):
		cell_offset_direction = value
		_set_offset()


@export var cell_offset_distance := 0.0:
	set(value):
		cell_offset_distance = value
		_set_offset()


var map: Map:
	set(value):
		if map and (self in map.actors):
			push_error("Actor not removed from old map using Map.remove_actor")
		if value and not (self in value.actors):
			push_error("Actor not added to new map using Map.add_actor")
		map = value


var remote_transform: RemoteTransform2D:
	get:
		return $Center/Offset/RemoteTransform2D


var facing: Vector2:
	set(value):
		if value.x < 0:
			_sprite.flip_h = true
		elif value.x > 0:
			_sprite.flip_h = false
		# else change nothing


@onready var _sprite: Sprite2D = $Center/Offset/Sprite
@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _offset: Node2D = $Center/Offset


func _exit_tree() -> void:
	map = null


func move_step(target_cell: Vector2i) -> void:
	assert((target_cell - origin_cell).length_squared() == 1)

	facing = target_cell
	cell_offset_direction = target_cell - origin_cell
	origin_cell = target_cell

	_anim.play("move_step")
	await _anim.animation_finished


func _set_offset() -> void:
	if _offset:
		_offset.position = cell_offset_direction.normalized() \
				* cell_offset_distance * Constants.TILE_SIZE
