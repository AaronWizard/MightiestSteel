class_name AttackActor
extends SkillEffect


func get_skill_target_info(source_actor: Actor, target_cell: Vector2i) \
		-> SkillTargetsData.TargetInfo:
	var result := SkillTargetsData.TargetInfo.new([], {})

	var target_actor := source_actor.map.get_actor_on_cell(target_cell)
	if target_actor:
		var aoe := target_actor.covered_cells
		var damage := target_actor.stats.predict_damage(
				source_actor.stats.attack)
		result = SkillTargetsData.TargetInfo.new(
			aoe,
			{ target_actor: damage  }
		)

	return result


func _run(source_actor: Actor, target_cell: Vector2i) -> void:
	var target_actor := source_actor.map.get_actor_on_cell(target_cell)
	var damage := target_actor.stats.predict_damage(source_actor.stats.attack)
	target_actor.stats.take_damage(damage)

	if target_actor.is_animating:
		await target_actor.animation_finished
