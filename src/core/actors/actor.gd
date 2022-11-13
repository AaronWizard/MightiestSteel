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


@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _offset: Node2D = $Center/Offset


func _set_offset() -> void:
	if _offset:
		_offset.position = cell_offset_direction.normalized() \
				* cell_offset_distance * Constants.TILE_SIZE
