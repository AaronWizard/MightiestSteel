@tool
class_name TileEffect
extends TileObject

@onready var _anim: AnimatedSprite2D = $Center/AnimatedSprite2D


func play() -> void:
	_anim.play()
	await _anim.animation_finished
	if not Engine.is_editor_hint():
		queue_free()
