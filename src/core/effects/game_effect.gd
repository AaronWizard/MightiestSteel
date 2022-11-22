class_name GameEffect
extends Resource

@export_range(0.0, 1.0, 0.001, "or_greater") var start_delay := 0.0


func get_skill_target_info(_source_cell: Vector2i, _target_cell: Vector2i,
		_source_actor: Actor) -> SkillTargetsData.TargetInfo:
	return SkillTargetsData.TargetInfo.new([], {})


func run(source_cell: Vector2i, target_cell: Vector2i, source_actor: Actor,
		tree: SceneTree) -> void:
	if start_delay > 0:
		await tree.create_timer(start_delay).timeout
	@warning_ignore(redundant_await)
	await _run(source_cell, target_cell, source_actor, tree)


func _run(_source_cell: Vector2i, _target_cell: Vector2i, _source_actor: Actor,
		_tree: SceneTree) -> void:
	push_warning("GameEffect: Need to implement _run()")
