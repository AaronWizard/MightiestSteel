class_name PoisonStatusEffect
extends StatusEffect

## Amount of damage to do each round. Is a percentage of the target's max
## stamina.
@export_range(0.05, 1, 0.05) var magnitude := 0.05

## Effect to play over the actor when taking damage
@export var tile_effect_scene: PackedScene


func _round_started() -> void:
	var animations: Array[Callable] = []
	if tile_effect_scene:
		animations.append(Callable(TileEffect, "play_on_field").bind(
				tile_effect_scene, actor.map, actor.covered_cells))

	var damage := maxi(int(float(actor.stats.max_stamina) * magnitude), 1)
	actor.stats.current_stamina -= damage
	animations.append(actor.wait_for_animation)

	await AwaitGroup.wait(animations)
