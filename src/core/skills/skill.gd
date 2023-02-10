class_name Skill
extends Resource

@export var name := "Skill"
@export_multiline var description := ""

## The skill's icon. Assumed to be 16x16.
@export var icon: Texture2D \
		= preload("res://assets/graphics/ui/icons/attack.png")

@export_range(1, 1, 1, "or_greater") var cooldown := 0

@export var target_range: TargetRange

@export var use_attack_anim := true


func get_targeting_data(source_actor: Actor,
		source_cell := source_actor.origin_cell) -> SkillTargetsData:
	source_actor.virtual_origin_cell = source_cell
	assert(source_actor.origin_cell == source_cell)

	var full_range := source_actor.covered_cells
	var valid_range := source_actor.covered_cells

	if target_range:
		var ranges := target_range.get_range(source_actor)
		full_range = ranges.full
		valid_range = ranges.valid

	var infos_by_target := {}
	for target_cell in valid_range:
		var target_info := _get_skill_target_info(source_actor, target_cell)
		infos_by_target[target_cell] = target_info

	source_actor.unset_virtual_origin_cell()

	return SkillTargetsData.new(full_range, valid_range, infos_by_target)


## Assumes target is within the skill's range
func run(source_actor: Actor, target: Vector2i) -> void:
	if use_attack_anim:
		source_actor.animate_attack(target)
		await source_actor.attack_hit

	@warning_ignore("redundant_await")
	await _run(source_actor, target)

	if source_actor.is_animating:
		await source_actor.animation_finished


# Can be overriden
func _get_skill_target_info(_source_actor: Actor, _target_cell: Vector2i) \
		-> SkillTargetsData.TargetInfo:
	return SkillTargetsData.TargetInfo.new([], {})


# Can be overriden
func _run(_source_actor: Actor, _target_cell: Vector2i) -> void:
	pass
