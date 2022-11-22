class_name GameEffectGroup
extends GameEffect

enum GroupType { GROUP, SEQUENCE }

@export var group_type := GroupType.GROUP
@export var children: Array[GameEffect]


func get_skill_target_info(source_cell: Vector2i, target_cell: Vector2i,
		source_actor: Actor) -> SkillTargetsData.TargetInfo:
	var result := SkillTargetsData.TargetInfo.new([], {})

	for c in children:
		var c_info := c.get_skill_target_info(source_cell, target_cell,
				source_actor)
		result.add(c_info)

	return result


func _run(source_cell: Vector2i, target_cell: Vector2i, source_actor: Actor,
		tree: SceneTree) -> void:
	var funcs: Array[Callable] = []
	for c in children:
		funcs.append(c.run.bind(source_cell, target_cell, source_actor, tree))
		if group_type == GroupType.SEQUENCE:
			for f in funcs:
				@warning_ignore(redundant_await)
				await f.call()
		else:
			await AwaitGroup.wait(funcs)
