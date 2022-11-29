@tool
class_name TileEffect
extends TileObject

signal finished

@onready var _anim: AnimatedSprite2D = $Center/AnimatedSprite2D


func start_anim() -> void:
	_anim.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	finished.emit()
	queue_free()
