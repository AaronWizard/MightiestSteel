class_name AttackStandard
extends AOESkill

@export var projectile_scene: PackedScene


func _run(source_actor: Actor, target_cell: Vector2i) -> void:
	await _run_projectile(target_cell, source_actor)
	await super(source_actor, target_cell)


func _run_projectile(target_cell: Vector2i, source_actor: Actor) -> void:
	if projectile_scene:
		var projectile: Projectile = projectile_scene.instantiate()

		projectile.start.origin_cell = source_actor.origin_cell
		projectile.start.cell_size = source_actor.cell_size

		if not aoe:
			var other_actor := source_actor.map.get_actor_on_cell(target_cell)
			if other_actor:
				projectile.end.origin_cell = other_actor.origin_cell
				projectile.end.cell_size = other_actor.cell_size
			else:
				projectile.end.origin_cell = target_cell
		else:
			projectile.end.origin_cell = target_cell

		source_actor.map.add_effect(projectile)
		await projectile.play()


func _predict_damage(target_actor: Actor, source_actor: Actor) -> int:
	return target_actor.predict_damage(
			source_actor.stats.attack, source_actor.center_cell)


func _run_on_actor(target_actor: Actor, source_actor: Actor) -> Array[Callable]:
	target_actor.take_damage(source_actor.stats.attack, source_actor.center_cell)
	return [target_actor.wait_for_animation]
