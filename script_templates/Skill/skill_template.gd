#class_name NewSkill
extends Skill


func _get_skill_target_info(_source_actor: Actor, _target_cell: Vector2i) \
		-> SkillTargetsData.TargetInfo:
	return SkillTargetsData.TargetInfo.new([], {})


func _run(_source_actor: Actor, _target_cell: Vector2i) -> void:
	pass
