class_name Projectile
extends Node2D


signal finished


## Sprite speed. In cells per second.
@export_range(0.001, 100, 0.001, "or_greater") var speed := 8
@export var rotate_projectile := false
@export var trans_type := Tween.TransitionType.TRANS_LINEAR
@export var ease_type := Tween.EaseType.EASE_IN

var start: TileObject:
	get:
		return $Start


var end: TileObject:
	get:
		return $End


@onready var _projectile: Node2D = $Projectile


func start_anim() -> void:
	var start_pos := start.center_position
	var end_pos := end.center_position

	var dist := start.center_cell.distance_to(end.center_cell)
	var total_time := float(dist) / float(speed)

	if rotate_projectile:
		_projectile.rotation = start_pos.angle_to_point(end_pos)

	await get_tree().create_tween() \
		.tween_property(_projectile, "position", end_pos, total_time) \
		.from(start_pos) \
		.set_trans(trans_type).set_ease(ease_type) \
		.finished

	finished.emit()
	queue_free()
