@tool
class_name Actor
extends TileObject


signal attack_hit


@export var cell_offset_direction := Vector2.ZERO:
	set(value):
		cell_offset_direction = value
		_set_offset()


@export var cell_offset_distance := 0.0:
	set(value):
		cell_offset_distance = value
		_set_offset()


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
