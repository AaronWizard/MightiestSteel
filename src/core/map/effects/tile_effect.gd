@tool
class_name TileEffect
extends TileObject

@onready var _anim: AnimatedSprite2D = $Center/AnimatedSprite2D


func play() -> void:
	_anim.play()
	await _anim.animation_finished
	if not Engine.is_editor_hint():
		queue_free()


static func play_on_field(effect_scene: PackedScene, map: Map,
		cells: Array[Vector2i]) -> void:
	var animations: Array[Callable] = []

	for c in cells:
		var tile_effect: TileEffect = effect_scene.instantiate()
		tile_effect.origin_cell = c
		map.add_effect(tile_effect)
		animations.append(tile_effect.play)

	await AwaitGroup.wait(animations)
