class_name SkillEffect
extends Resource

@export_range(0.0, 1.0, 0.001, "or_greater") var start_delay := 0.0


func get_skill_target_info(_source_actor: Actor, _target_cell: Vector2i) \
		-> SkillTargetsData.TargetInfo:
	return SkillTargetsData.TargetInfo.new([], {})


func run(source_actor: Actor, target_cell: Vector2i) -> void:
	if start_delay > 0:
		await source_actor.get_tree().create_timer(start_delay).timeout
	@warning_ignore(redundant_await)
	await _run(source_actor, target_cell)


func _run(_source_actor: Actor, _target_cell: Vector2i) -> void:
	push_warning("GameEffect: Need to implement _run()")
