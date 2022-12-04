class_name AttackStandard
extends Skill

enum TileEffectRangeType
{
	FULL, ## Tile effects will go on tiles in the AOE's full range
	VALID_ONLY, ## Tile effects will go on tiles in the AOE's valid range
	ACTORS ## Tile effects will go on tiles covered by actors in the AOE
}

@export var aoe: AOE

@export var projectile_scene: PackedScene
@export var tile_effect_scene: PackedScene
@export var tile_effect_range_type := TileEffectRangeType.FULL


func _get_skill_target_info(source_actor: Actor, target_cell: Vector2i) \
		-> SkillTargetsData.TargetInfo:
	var aoe_data := _get_aoe_data(target_cell, source_actor)

	var predicted_damage := {}
	for a in aoe_data.actors:
		predicted_damage[a] = a.predict_damage(
				source_actor.stats.attack, source_actor.center_cell)

	return SkillTargetsData.TargetInfo.new(aoe_data.full, predicted_damage)


func _run(source_actor: Actor, target_cell: Vector2i) -> void:
	var aoe_data := _get_aoe_data(target_cell, source_actor)


	if projectile_scene:
		var projectile: Projectile = projectile_scene.instantiate()

		projectile.start.origin_cell = source_actor.origin_cell
		projectile.start.cell_size = source_actor.cell_size

		if (aoe_data.actors.size() == 1) \
				and aoe_data.actors[0].is_on_cell(target_cell):
			projectile.end.origin_cell = aoe_data.actors[0].origin_cell
			projectile.end.cell_size = aoe_data.actors[0].cell_size
		else:
			projectile.end.origin_cell = target_cell

		source_actor.map.add_effect(projectile)
		await projectile.play()

	var animations: Array[Callable] = []

	if tile_effect_scene \
			and not tile_effect_range_type == TileEffectRangeType.ACTORS:
		var effect_range: Array[Vector2i]
		if tile_effect_range_type == TileEffectRangeType.FULL:
			effect_range = aoe_data.full
		else:
			assert(tile_effect_range_type == TileEffectRangeType.VALID_ONLY)
			effect_range = aoe_data.valid
		for c in effect_range:
			var tile_effect := _create_tile_effect(c)
			source_actor.map.add_effect(tile_effect)
			animations.append(tile_effect.play)

	for a in aoe_data.actors:
		if tile_effect_scene \
				and tile_effect_range_type == TileEffectRangeType.ACTORS:
			for c in a.covered_cells:
				var tile_effect := _create_tile_effect(c)
				source_actor.map.add_effect(tile_effect)
				animations.append(tile_effect.play)

		a.take_damage(source_actor.stats.attack, source_actor.center_cell)
		animations.append(_wait_for_actor_animation.bind(a))

	await AwaitGroup.wait(animations)


func _get_aoe_data(target_cell: Vector2i, source_actor: Actor) \
		-> TargetRangeData:
	var result: TargetRangeData
	if aoe:
		result = aoe.get_aoe(target_cell, source_actor)
	else:
		result = TargetRangeData.new(
				[target_cell], TargetRangeData.TargetType.ENEMY, source_actor)
	return result


func _create_tile_effect(cell: Vector2i) -> TileEffect:
	var result: TileEffect = tile_effect_scene.instantiate()
	result.origin_cell = cell
	return result


static func _wait_for_actor_animation(actor: Actor) -> void:
	if actor.is_animating:
		await actor.animation_finished
