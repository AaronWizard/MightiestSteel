class_name SkillTargetsData

## Describe the AOE and predicted damage to any actors of all targets within a
## skill's target range.

class TargetInfo:
	## Describe AOE and predicted damage of a skill's target.
	##
	## Gets the following information:
	## - The full AOE of the target.
	## - Predicted damage of all actors affected by the skill at this target.
	##   Negative values are healing.


	## The full AOE of the target.
	var aoe: Array[Vector2i]:
		get:
			return _aoe


	## Predicted damage of all actors affected by the skill at this target.
	## Keys are Actors, values are ints. Negative values are healing.
	var predicted_damage: Dictionary:
		get:
			return _predicted_damage


	var _aoe: Array[Vector2i]
	var _predicted_damage := {}


	## For new_predicted_damage, keys are Actors and values are ints. Negative
	## values indicate healing.
	func _init(new_aoe: Array[Vector2i], new_predicted_damage: Dictionary) \
			-> void:
		_aoe = new_aoe
		_predicted_damage = new_predicted_damage


	func add(other: TargetInfo) -> void:
		for c in other._aoe:
			if not _aoe.has(c):
				_aoe.append(c)

		for a in other._predicted_damage:
			if _predicted_damage.has(a):
				_predicted_damage[a] += other._predicted_damage[a]
			else:
				_predicted_damage[a] = other._predicted_damage[a]


## All cells that may potentially be targeted by the skill.
## What is shown on the map to the player.
##
## e.g. If a skill has a range of four cells but can only target actors, this
## contains all cells within four cells regardless of whether actors are on them
## or not.
var target_range: Array[Vector2i]:
	get:
		return _target_range


## All cells that may actually be targeted by the actor using the skill.
##
## e.g. If a skill has a range of four cells but can only target actors, this
## contains only the origin cells of the actors within range.
var valid_targets: Array[Vector2i]:
	get:
		return _valid_targets.keys()


var _target_range: Array[Vector2i]
var _valid_targets: Dictionary # Keys are Vector2is.
var _target_infos: Dictionary # Keys are Vector2is. Values are TargetInfos.


## For target_infos, keys are Vector2is and values are TargetInfos.
func _init(new_target_range: Array[Vector2i],
		new_valid_targets: Array[Vector2i], new_target_infos: Dictionary) \
		-> void:
	_target_range = new_target_range

	for c in new_valid_targets:
		_valid_targets[c] = true

	_target_infos = new_target_infos


## Returns true if given target is a valid target
func is_valid_target(cell: Vector2i) -> bool:
	return _valid_targets.has(cell)


## Gets the TargetInfo of a valid target. TargetInfo describes the AOE and
## predicted damage to any actors of the target.
func get_target_info(target: Vector2i) -> TargetInfo:
	var result: TargetInfo = null
	if _target_infos.has(target):
		result = _target_infos[target]
	return result
