class_name AOESkill
extends Skill

enum TileEffectRangeType
{
	FULL, ## Tile effects will go on tiles in the AOE's full range
	VALID_ONLY, ## Tile effects will go on tiles in the AOE's valid range
	ACTORS ## Tile effects will go on tiles covered by actors in the AOE
}

@export var aoe: AOE
@export var tile_effect_scene: PackedScene
@export var tile_effect_range_type := TileEffectRangeType.FULL

@export var status_effects: Array[StatusEffect]


func _get_skill_target_info(source_actor: Actor, target_cell: Vector2i) \
		-> SkillTargetsData.TargetInfo:
	var aoe_data := _get_aoe_data(target_cell, source_actor)

	var predicted_damage := {}
	for a in aoe_data.actors:
		var damage := _predict_damage(a, source_actor)
		if damage != 0:
			predicted_damage[a] = damage

	return SkillTargetsData.TargetInfo.new(aoe_data.full, predicted_damage)


func _run(source_actor: Actor, target_cell: Vector2i) -> void:
	var aoe_data := _get_aoe_data(target_cell, source_actor)
	var animations: Array[Callable] = []

	var actor_covered_cells := {}
	for a in aoe_data.actors:
		var actor_anims := _run_on_actor(a, source_actor)
		animations.append_array(actor_anims)

		if tile_effect_scene \
				and tile_effect_range_type == TileEffectRangeType.ACTORS:
			for c in a.covered_cells:
				actor_covered_cells[c] = true

		for s in status_effects:
			a.add_status_effect(s)

	var tile_anims := _start_tile_effects(
			source_actor.map, aoe_data, actor_covered_cells)
	animations.append_array(tile_anims)

	await AwaitGroup.wait(animations)


func _get_aoe_data(target_cell: Vector2i, source_actor: Actor) \
		-> TargetRangeData:
	var result: TargetRangeData
	if aoe:
		result = aoe.get_aoe(target_cell, source_actor)
	else:
		result = TargetRangeData.new([target_cell],
				TargetRangeData.TargetType.ANY_ACTOR, source_actor)
	return result


func _start_tile_effects(map: Map, aoe_data: TargetRangeData,
		actor_covered_cells: Dictionary) -> Array[Callable]:
	var animations: Array[Callable] = []

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
				tile_effect_scene, map, tile_effect_cells)
		)

	return animations


# Can be overriden
func _predict_damage(_target_actor: Actor, _source_actor: Actor) -> int:
	return 0


func _run_on_actor(_target_actor: Actor, _source_actor: Actor) \
		-> Array[Callable]:
	return []
