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
@export var status_effects: Array[StatusEffect]


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

	var actor_covered_cells := {}
	for a in aoe_data.actors:
		a.take_damage(source_actor.stats.attack, source_actor.center_cell)
		animations.append(a.wait_for_animation)

		if tile_effect_scene \
				and tile_effect_range_type == TileEffectRangeType.ACTORS:
			for c in a.covered_cells:
				actor_covered_cells[c] = true

		for s in status_effects:
			a.add_status_effect(s)

	if tile_effect_scene:
		var tile_effect_cells: Array[Vector2i] = []
		match tile_effect_range_type:
			TileEffectRangeType.FULL:
				tile_effect_cells = aoe_data.full
			TileEffectRangeType.VALID_ONLY:
				tile_effect_cells = aoe_data.valid
			_:
				assert(not actor_covered_cells.is_empty())
				tile_effect_cells = actor_covered_cells.keys()

		animations.append(
			Callable(TileEffect, "play_on_field").bind(
				tile_effect_scene, source_actor.map, tile_effect_cells)
		)

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
