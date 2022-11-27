class_name GameEffectGroup
extends SkillEffect

enum GroupType { GROUP, SEQUENCE }

@export var group_type := GroupType.GROUP
@export var children: Array[SkillEffect]


func get_skill_target_info(source_actor: Actor, target_cell: Vector2i) \
		-> SkillTargetsData.TargetInfo:
	var result := SkillTargetsData.TargetInfo.new([], {})

	for c in children:
		var c_info := c.get_skill_target_info(source_actor, target_cell)
		result.add(c_info)

	return result


func _run(source_actor: Actor, target_cell: Vector2i) -> void:
	var funcs: Array[Callable] = []
	for c in children:
		funcs.append(c.run.bind(source_actor, target_cell))
		if group_type == GroupType.SEQUENCE:
			for f in funcs:
				@warning_ignore(redundant_await)
				await f.call()
		else:
			await AwaitGroup.wait(funcs)
