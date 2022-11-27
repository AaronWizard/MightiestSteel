class_name Skill
extends Resource

@export var name := "Skill"
@export var description := ""
@export var icon: Texture2D
@export_range(1, 1, 1, "or_greater") var cooldown := 0

@export var target_range: TargetRange
#@export var effect: GameEffect

@export var use_attack_anim := true


func get_targeting_data(source_actor: Actor,
		source_cell := source_actor.origin_cell) -> SkillTargetsData:
	source_actor.virtual_origin_cell = source_cell

	var full_range := source_actor.covered_cells
	var valid_range := source_actor.covered_cells

	if target_range:
		var ranges := target_range.get_range(source_actor)
		full_range = ranges.full
		valid_range = ranges.valid

	var infos_by_target := {}
#	for target_cell in valid_range:
#		var target_info := effect.get_skill_target_info(
#			source_actor.origin_cell, target_cell, source_actor)
#		infos_by_target[target_cell] = target_info

	source_actor.unset_virtual_origin_cell()

	return SkillTargetsData.new(
			source_cell, full_range, valid_range, infos_by_target)


## Assumes target is within the skill's range
func run(source_actor: Actor, target: Vector2i) -> void:
	if use_attack_anim:
		source_actor.animate_attack(target)
		await source_actor.attack_hit
		print("attack hit")
	if source_actor.is_animating:
		await source_actor.animation_finished
		print("finished skill")
#	await effect.run(source_actor.origin_cell, target, source_actor,
#			source_actor.get_tree())
