class_name AttackStandard
extends Skill


@export var projectile_scene: PackedScene
@export var aoe: AOE


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
		await projectile.start_anim()

	var animations: Array[Callable] = []

	for a in aoe_data.actors:
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


static func _wait_for_actor_animation(actor: Actor) -> void:
	if actor.is_animating:
		await actor.animation_finished
